import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// ============================================================
// 難易度自動更新 Edge Function
// Supabase Cron で7日ごとに実行:
//   schedule: "0 9 * * 1" (毎週月曜 9:00 JST = 00:00 UTC)
// ============================================================

interface DifficultyMetrics {
  noEditRate: number    // 修正なしで送信した割合（0-1）
  avgRetries: number    // 平均リトライ数
  totalTurns: number    // 集計期間のターン数
}

/**
 * 7日間の使用量ログからDifficultyMetricsを計算
 */
async function calcMetrics(
  supabase: ReturnType<typeof createClient>,
  userId: string
): Promise<DifficultyMetrics | null> {
  const sevenDaysAgo = new Date()
  sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)
  const fromDate = sevenDaysAgo.toISOString().split('T')[0]

  const { data: logs, error } = await supabase
    .from('usage_logs')
    .select('turns_used, edit_count, retry_count, date')
    .eq('user_id', userId)
    .gte('date', fromDate)

  if (error || !logs || logs.length === 0) return null

  const totalTurns = logs.reduce((sum, l) => sum + (l.turns_used || 0), 0)
  const totalEdits = logs.reduce((sum, l) => sum + (l.edit_count || 0), 0)
  const totalRetries = logs.reduce((sum, l) => sum + (l.retry_count || 0), 0)

  if (totalTurns === 0) return null

  return {
    noEditRate: 1 - totalEdits / totalTurns,
    avgRetries: totalRetries / totalTurns,
    totalTurns,
  }
}

/**
 * 難易度計算ロジック
 * noEditRate > 0.8 && avgRetries < 0.5 → level + 1
 * noEditRate < 0.4 || avgRetries > 2.0 → level - 1
 * otherwise                             → level 維持
 */
function calcNextLevel(current: number, metrics: DifficultyMetrics): number {
  if (metrics.noEditRate > 0.8 && metrics.avgRetries < 0.5) {
    return Math.min(4, current + 1)
  }
  if (metrics.noEditRate < 0.4 || metrics.avgRetries > 2.0) {
    return Math.max(1, current - 1)
  }
  return current
}

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
    const supabase = createClient(supabaseUrl, supabaseKey)

    // アクティブユーザー一覧を取得（過去7日にアクセスあり）
    const sevenDaysAgo = new Date()
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)

    const { data: activeUsers, error: usersErr } = await supabase
      .from('users')
      .select('id, current_level')
      .gte('last_active', sevenDaysAgo.toISOString().split('T')[0])

    if (usersErr || !activeUsers) {
      throw new Error('Failed to fetch active users')
    }

    const results = {
      updated: 0,
      unchanged: 0,
      skipped: 0,
      details: [] as Array<{ userId: string; from: number; to: number }>,
    }

    for (const user of activeUsers) {
      const metrics = await calcMetrics(supabase, user.id)

      if (!metrics || metrics.totalTurns < 5) {
        // データ不足はスキップ（最低5ターン必要）
        results.skipped++
        continue
      }

      const nextLevel = calcNextLevel(user.current_level, metrics)

      if (nextLevel !== user.current_level) {
        await supabase
          .from('users')
          .update({ current_level: nextLevel })
          .eq('id', user.id)

        results.updated++
        results.details.push({
          userId: user.id,
          from: user.current_level,
          to: nextLevel,
        })
      } else {
        results.unchanged++
      }
    }

    console.log(`Difficulty update complete: ${JSON.stringify(results)}`)

    return new Response(
      JSON.stringify({ success: true, ...results }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Difficulty updater error:', error)
    return new Response(
      JSON.stringify({ error: 'INTERNAL_ERROR', message: String(error) }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
