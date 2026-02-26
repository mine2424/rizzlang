import { SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2'

// ============================================================
// 共通認証ミドルウェア + レート制限
// ============================================================

/**
 * JWT 検証
 * Authorization: Bearer <jwt> ヘッダーを検証し、ユーザーを返す
 * 返り値: { user, error }
 */
export async function verifyAuth(
  req: Request,
  supabase: SupabaseClient
): Promise<{ user: { id: string; email?: string } | null; error: Response | null }> {
  const authHeader = req.headers.get('Authorization')

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return {
      user: null,
      error: new Response(
        JSON.stringify({ error: 'UNAUTHORIZED', message: 'Missing or invalid Authorization header' }),
        {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        }
      ),
    }
  }

  const jwt = authHeader.replace('Bearer ', '')

  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser(jwt)

  if (authError || !user) {
    return {
      user: null,
      error: new Response(
        JSON.stringify({ error: 'UNAUTHORIZED', message: 'Invalid or expired token' }),
        {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        }
      ),
    }
  }

  return { user, error: null }
}

/**
 * レート制限チェック
 * usage_logs テーブルの updated_at を使って windowSeconds 内のリクエスト数をカウント
 * デフォルト: 60秒間に最大10リクエスト
 * 返り値: { allowed, error }
 */
export async function checkRateLimit(
  userId: string,
  supabase: SupabaseClient,
  windowSeconds = 60,
  maxRequests = 10
): Promise<{ allowed: boolean; error: Response | null }> {
  const windowStart = new Date(Date.now() - windowSeconds * 1000).toISOString()

  // usage_logs テーブルから windowSeconds 内のレコードをカウント
  const { count, error: countError } = await supabase
    .from('usage_logs')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('updated_at', windowStart)

  if (countError) {
    // レート制限チェック失敗の場合は通過させる（可用性優先）
    console.error('Rate limit check error:', countError)
    return { allowed: true, error: null }
  }

  const requestCount = count ?? 0

  if (requestCount >= maxRequests) {
    return {
      allowed: false,
      error: new Response(
        JSON.stringify({
          error: 'RATE_LIMIT_EXCEEDED',
          message: `Rate limit exceeded: ${maxRequests} requests per ${windowSeconds} seconds`,
          retryAfter: windowSeconds,
        }),
        {
          status: 429,
          headers: {
            'Content-Type': 'application/json',
            'Retry-After': String(windowSeconds),
          },
        }
      ),
    }
  }

  return { allowed: true, error: null }
}
