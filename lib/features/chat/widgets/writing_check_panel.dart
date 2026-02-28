import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/revenue_cat_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../paywall/paywall_sheet.dart';

// ────────────────────────────────────────────────
// 今日の添削残り回数プロバイダー（Free ユーザー向け）
// ────────────────────────────────────────────────
final writingCheckUsageProvider = FutureProvider<int>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return 5;

  final today = DateTime.now().toIso8601String().split('T')[0];
  try {
    final result = await supabase
        .from('conversations')
        .select('id')
        .eq('user_id', userId)
        .eq('message_type', 'writing_check')
        .gte('created_at', '${today}T00:00:00Z');

    final used = (result as List).length;
    return (5 - used).clamp(0, 5);
  } catch (_) {
    return 5;
  }
});

// ────────────────────────────────────────────────
// WritingCheckPanel
// ────────────────────────────────────────────────
class WritingCheckPanel extends ConsumerWidget {
  const WritingCheckPanel({super.key, required this.result});
  final WritingCheckResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: AppTheme.primary.withOpacity(0.3)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 残り回数バナー（Free ユーザー・残り3回以下） ──
          _UsageCounterBanner(),

          // ── タイトルバー ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                const Text(
                  '📝 添削結果',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                _buildScoreRing(result.score),
              ],
            ),
          ),

          // ── 添削後テキスト ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withOpacity(0.25)),
              ),
              child: Text(
                result.corrected,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text1,
                  height: 1.5,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1, end: 0),

          // ── エラー一覧 ──
          if (result.errors.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'エラーなし！完璧です 🎉',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Column(
                children: result.errors
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildErrorRow(entry.value)
                          .animate(delay: (entry.key * 50).ms)
                          .fadeIn(duration: 200.ms),
                    )
                    .toList(),
              ),
            ),

          // ── 称賛 ──
          if (result.praise.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
              child: Row(
                children: [
                  const Text('💪 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      result.praise,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 200.ms),

          // ── Tip ──
          if (result.tip.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  const Text('💡 ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      result.tip,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.text2,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 200.ms),
        ],
      ),
    );
  }

  Widget _buildScoreRing(int score) {
    final color = score >= 90
        ? AppTheme.success
        : score >= 70
            ? AppTheme.gold
            : AppTheme.tension;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            backgroundColor: AppTheme.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  '点',
                  style: TextStyle(
                    fontSize: 8,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorRow(WritingError error) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.tensionBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.tension.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('⚠ ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12.5),
                    children: [
                      TextSpan(
                        text: error.original,
                        style: const TextStyle(
                          color: AppTheme.tension,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppTheme.tension,
                        ),
                      ),
                      const TextSpan(
                        text: '  →  ',
                        style: TextStyle(color: AppTheme.text3),
                      ),
                      TextSpan(
                        text: error.corrected,
                        style: const TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  error.explanation,
                  style: const TextStyle(fontSize: 11, color: AppTheme.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────
// 残り回数バナー（Consumer で Pro ステータス + 使用量を監視）
// ────────────────────────────────────────────────
class _UsageCounterBanner extends ConsumerWidget {
  const _UsageCounterBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(proStatusProvider).valueOrNull ?? false;
    final remaining = ref.watch(writingCheckUsageProvider).valueOrNull ?? 5;

    // Pro ユーザーまたは残り回数が余裕がある場合は表示しない
    if (isPro || remaining > 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: remaining == 0 ? AppTheme.tensionBg : AppTheme.primaryGlow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: remaining == 0
              ? AppTheme.tension.withOpacity(0.3)
              : AppTheme.borderGlow,
        ),
      ),
      child: Row(
        children: [
          Text(
            remaining == 0 ? '⚠' : '📝',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              remaining == 0
                  ? '今日の添削上限に達しました。Proで無制限に。'
                  : '今日あと $remaining 回添削できます（Freeプラン）',
              style: TextStyle(
                fontSize: 11.5,
                color: remaining == 0 ? AppTheme.tension : AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (remaining == 0)
            GestureDetector(
              onTap: () => showPaywallSheet(context),
              child: Text(
                'Pro →',
                style: TextStyle(
                  fontSize: 11.5,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
