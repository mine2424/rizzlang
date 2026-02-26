import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { encode as base64Encode } from 'https://deno.land/std@0.168.0/encoding/base64url.ts'

// ============================================================
// FCM デイリーリマインダー送信 Edge Function
//
// Supabase Cron で毎日 9:00 JST (= 0:00 UTC) に実行:
//   schedule: "0 0 * * *"
//
// 必要な Secrets:
//   FIREBASE_SERVICE_ACCOUNT_JSON — Firebase サービスアカウント JSON 全文
//   SUPABASE_URL
//   SUPABASE_SERVICE_ROLE_KEY
// ============================================================

interface ServiceAccount {
  project_id: string
  private_key_id: string
  private_key: string
  client_email: string
  token_uri: string
}

interface FcmResult {
  success: number
  failure: number
  invalidTokens: string[]
}

// ────────────────────────────────────────────────
// Google OAuth2 アクセストークン取得（Service Account JWT 認証）
// ────────────────────────────────────────────────
async function getGoogleAccessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const exp = now + 3600

  // JWT ヘッダー・ペイロード
  const header = { alg: 'RS256', typ: 'JWT' }
  const payload = {
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp,
  }

  const enc = new TextEncoder()
  const headerB64 = base64Encode(enc.encode(JSON.stringify(header)))
  const payloadB64 = base64Encode(enc.encode(JSON.stringify(payload)))
  const signingInput = `${headerB64}.${payloadB64}`

  // PEM 秘密鍵を DER に変換して署名
  const pemBody = sa.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\n/g, '')
  const der = Uint8Array.from(atob(pemBody), (c) => c.charCodeAt(0))

  const cryptoKey = await crypto.subtle.importKey(
    'pkcs8',
    der.buffer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign']
  )

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    enc.encode(signingInput)
  )

  const jwt = `${signingInput}.${base64Encode(new Uint8Array(signature))}`

  // JWT を access_token に交換
  const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })

  const tokenData = await tokenRes.json()
  if (!tokenData.access_token) {
    throw new Error(`Failed to get access token: ${JSON.stringify(tokenData)}`)
  }

  return tokenData.access_token as string
}

// ────────────────────────────────────────────────
// FCM v1 API でメッセージ送信
// ────────────────────────────────────────────────
async function sendFcmNotification(
  accessToken: string,
  projectId: string,
  token: string,
  title: string,
  body: string
): Promise<{ success: boolean; isInvalidToken: boolean }> {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          data: {
            click_action: '/chat',
            type: 'daily_reminder',
          },
          android: {
            notification: {
              channel_id: 'rizzlang_reminders',
              priority: 'HIGH',
            },
          },
          apns: {
            payload: {
              aps: {
                sound: 'default',
                badge: 1,
              },
            },
          },
        },
      }),
    }
  )

  if (res.ok) return { success: true, isInvalidToken: false }

  const err = await res.json()
  const isInvalidToken =
    err?.error?.details?.some(
      (d: { errorCode: string }) =>
        d.errorCode === 'UNREGISTERED' || d.errorCode === 'INVALID_ARGUMENT'
    ) ?? false

  return { success: false, isInvalidToken }
}

// ────────────────────────────────────────────────
// メインハンドラー
// ────────────────────────────────────────────────
serve(async (req: Request) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const saJson = Deno.env.get('FIREBASE_SERVICE_ACCOUNT_JSON')!

    const sa: ServiceAccount = JSON.parse(saJson)
    const supabase = createClient(supabaseUrl, supabaseKey)

    // ── 対象ユーザーを抽出 ──
    // 条件: 前日にアクセスあり & 当日未アクセス
    const today = new Date().toISOString().split('T')[0]
    const yesterday = new Date(Date.now() - 86400000).toISOString().split('T')[0]

    const { data: targets, error: targetsErr } = await supabase
      .from('users')
      .select('id')
      .eq('last_active', yesterday) // 前日最終アクセス = 当日まだ開いていない

    if (targetsErr) throw new Error('Failed to fetch target users')

    if (!targets || targets.length === 0) {
      return new Response(
        JSON.stringify({ success: true, message: 'No target users', sent: 0 }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const userIds = targets.map((u) => u.id)

    // ── 有効なFCMトークンを取得 ──
    const { data: tokenRows, error: tokensErr } = await supabase
      .from('fcm_tokens')
      .select('user_id, token')
      .in('user_id', userIds)
      .eq('enabled', true)

    if (tokensErr) throw new Error('Failed to fetch FCM tokens')
    if (!tokenRows || tokenRows.length === 0) {
      return new Response(
        JSON.stringify({ success: true, message: 'No FCM tokens', sent: 0 }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // ── Google アクセストークン取得 ──
    const accessToken = await getGoogleAccessToken(sa)

    // ── 通知送信 ──
    const result: FcmResult = { success: 0, failure: 0, invalidTokens: [] }

    // 並列送信（最大10件ずつ）
    const BATCH = 10
    for (let i = 0; i < tokenRows.length; i += BATCH) {
      const batch = tokenRows.slice(i, i + BATCH)
      await Promise.all(
        batch.map(async (row) => {
          const res = await sendFcmNotification(
            accessToken,
            sa.project_id,
            row.token,
            '지우からメッセージが届いています 🥺',
            '오빠, 오늘도 연락해줘서 좋아... 기다리고 있어!'
          )
          if (res.success) {
            result.success++
          } else {
            result.failure++
            if (res.isInvalidToken) {
              result.invalidTokens.push(row.token)
            }
          }
        })
      )
    }

    // ── 無効トークンを DB から削除 ──
    if (result.invalidTokens.length > 0) {
      await supabase
        .from('fcm_tokens')
        .delete()
        .in('token', result.invalidTokens)
      console.log(`Deleted ${result.invalidTokens.length} invalid tokens`)
    }

    console.log(`FCM scheduler done: ${JSON.stringify(result)}`)

    return new Response(
      JSON.stringify({ success: true, ...result }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('FCM scheduler error:', error)
    return new Response(
      JSON.stringify({ error: 'INTERNAL_ERROR', message: String(error) }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
