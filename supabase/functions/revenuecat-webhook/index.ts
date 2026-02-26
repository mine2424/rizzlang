import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { createHmac } from 'https://deno.land/std@0.168.0/node/crypto.ts'

// ============================================================
// RevenueCat Webhook Handler
// RevenueCat Dashboard → Project Settings → Webhooks に登録:
//   URL: https://<project>.supabase.co/functions/v1/revenuecat-webhook
//   Authorization: REVENUECAT_WEBHOOK_SECRET（環境変数と同じ値）
// ============================================================

// RevenueCat イベントタイプ（処理対象のみ定義）
type RCEventType =
  | 'INITIAL_PURCHASE'        // 初回購入
  | 'RENEWAL'                  // 自動更新
  | 'PRODUCT_CHANGE'           // プラン変更
  | 'CANCELLATION'             // キャンセル（期間終了まで有効）
  | 'UNCANCELLATION'           // キャンセル取り消し
  | 'NON_RENEWING_PURCHASE'    // 買い切り購入
  | 'SUBSCRIPTION_PAUSED'      // サブスク一時停止（Android）
  | 'EXPIRATION'               // 有効期限切れ（plan を free に戻す）
  | 'BILLING_ISSUE'            // 支払い失敗
  | 'SUBSCRIBER_ALIAS'         // ユーザー統合

interface RCWebhookPayload {
  api_version: string
  event: {
    aliases: string[]
    app_id: string
    app_user_id: string        // RevenueCat の app_user_id（= Supabase UID）
    original_app_user_id: string
    type: RCEventType
    product_id: string
    entitlement_ids: string[]  // ['pro']
    expiration_at_ms: number | null
    environment: 'PRODUCTION' | 'SANDBOX'
    store: 'APP_STORE' | 'PLAY_STORE' | 'PROMOTIONAL'
    is_family_share?: boolean
    cancel_reason?: string
    expiration_reason?: string
  }
}

function verifySignature(body: string, authHeader: string | null, secret: string): boolean {
  if (!authHeader) return false
  // RevenueCat は Authorization ヘッダーに直接 secret を送る
  return authHeader === secret
}

serve(async (req: Request) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  // POST のみ受け付ける
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const webhookSecret = Deno.env.get('REVENUECAT_WEBHOOK_SECRET')!

    // ── 署名検証 ──
    const authHeader = req.headers.get('Authorization')
    if (!verifySignature('', authHeader, webhookSecret)) {
      console.warn('RevenueCat webhook: Invalid authorization')
      return new Response(JSON.stringify({ error: 'UNAUTHORIZED' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const payload: RCWebhookPayload = await req.json()
    const event = payload.event

    // SANDBOX イベントはログだけ残してスキップ（本番に影響させない）
    if (event.environment === 'SANDBOX') {
      console.log(`[SANDBOX] RevenueCat event: ${event.type} for ${event.app_user_id}`)
      return new Response(JSON.stringify({ received: true, skipped: 'sandbox' }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(supabaseUrl, supabaseKey)
    const userId = event.app_user_id

    // ── plan 更新ロジック ──
    let newPlan: 'free' | 'pro' | null = null

    switch (event.type) {
      // Pro に上げる
      case 'INITIAL_PURCHASE':
      case 'RENEWAL':
      case 'UNCANCELLATION':
      case 'NON_RENEWING_PURCHASE':
      case 'PRODUCT_CHANGE':
        if (event.entitlement_ids.includes('pro')) {
          newPlan = 'pro'
        }
        break

      // Free に戻す
      case 'EXPIRATION':
      case 'BILLING_ISSUE':
        newPlan = 'free'
        break

      // キャンセルは期間満了まで Pro のまま（EXPIRATION で free に戻す）
      case 'CANCELLATION':
        console.log(`User ${userId} cancelled - keeping pro until expiration`)
        break

      default:
        console.log(`RevenueCat: Unhandled event type: ${event.type}`)
    }

    if (newPlan !== null) {
      const { error } = await supabase
        .from('users')
        .update({ plan: newPlan })
        .eq('id', userId)

      if (error) {
        console.error(`Failed to update plan for ${userId}:`, error)
        return new Response(JSON.stringify({ error: 'DB_UPDATE_FAILED' }), {
          status: 500,
          headers: { 'Content-Type': 'application/json' },
        })
      }

      console.log(`Plan updated: ${userId} → ${newPlan} (event: ${event.type})`)
    }

    return new Response(
      JSON.stringify({ received: true }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('RevenueCat webhook error:', error)
    return new Response(
      JSON.stringify({ error: 'INTERNAL_ERROR' }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
