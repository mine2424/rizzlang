import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/streak_provider.dart';

// ────────────────────────────────────────────────
// マイルストーン表示済みフラグ（セッション内で1回だけ表示）
// ────────────────────────────────────────────────
final _milestoneShownProvider = StateProvider<bool>((ref) => false);

class StreakBar extends ConsumerWidget {
  const StreakBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakDataProvider);

    return streakAsync.when(
      loading: () => const _StreakBarSkeleton(),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        // マイルストーン達成 → 1回だけオーバーレイ表示
        final shown = ref.watch(_milestoneShownProvider);
        if (data.newMilestone != null && !shown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(_milestoneShownProvider.notifier).state = true;
            _showMilestoneOverlay(context, data.newMilestone!);
          });
        }

        return _StreakBarContent(data: data);
      },
    );
  }

  void _showMilestoneOverlay(BuildContext context, int milestone) {
    final messages = {
      7: ('🔥', '7日連続！', '1週間続けた！最高だ！'),
      30: ('🌟', '30日連続！', '1ヶ月！本物の習慣になったね！'),
      100: ('👑', '100日連続！', '伝説のレベルに到達！'),
    };
    final (emoji, title, sub) = messages[milestone] ?? ('🎉', '達成！', '');

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _MilestoneDialog(
        emoji: emoji,
        title: title,
        subtitle: sub,
        days: milestone,
      ),
    );
  }
}

// ────────────────────────────────────────────────
// StreakBar 本体
// ────────────────────────────────────────────────
class _StreakBarContent extends StatelessWidget {
  const _StreakBarContent({required this.data});
  final StreakData data;

  @override
  Widget build(BuildContext context) {
    final xpText = data.todayXp == 0 ? '' : '+${data.todayXp} XP';
    final today = DateTime.now();
    // 月曜始まりで 0(月)〜6(日)
    final todayWeekdayIndex = (today.weekday - 1) % 7;
    const dayLabels = ['月', '火', '水', '木', '金', '土', '日'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.06),
        border: Border(
          bottom: BorderSide(color: AppTheme.primary.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          // 🔥 ストリーク
          _StreakCount(streak: data.streak),
          const SizedBox(width: 12),

          // 7ドット曜日表示
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isToday = i == todayWeekdayIndex;
                // ストリーク日数で「今日より前の何日か」が完了
                final daysSinceMonday = i;
                final isDone = data.streak > 0 &&
                    daysSinceMonday < todayWeekdayIndex + (data.todayXp > 0 ? 1 : 0);
                return _buildDayDot(dayLabels[i], isDone, isToday);
              }),
            ),
          ),

          // XP バッジ
          if (xpText.isNotEmpty) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                xpText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
          ],
        ],
      ),
    );
  }

  Widget _buildDayDot(String label, bool isDone, bool isToday) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: isToday ? AppTheme.primaryGradient : null,
        color: isToday
            ? null
            : isDone
                ? AppTheme.primary.withOpacity(0.15)
                : AppTheme.surface2,
        border: Border.all(
          color: isToday
              ? Colors.transparent
              : isDone
                  ? AppTheme.primary.withOpacity(0.3)
                  : AppTheme.border,
        ),
        boxShadow: isToday ? AppTheme.primaryShadow : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isToday
                ? Colors.white
                : isDone
                    ? AppTheme.primary
                    : AppTheme.text3,
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
// ストリーク数表示
// ────────────────────────────────────────────────
class _StreakCount extends StatelessWidget {
  const _StreakCount({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final isHot = streak >= 3;
    final emoji = streak >= 30 ? '👑' : streak >= 7 ? '🌟' : '🔥';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 4),
        Text(
          '$streak日',
          style: TextStyle(
            color: isHot ? AppTheme.primary : Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────
// スケルトンローディング
// ────────────────────────────────────────────────
class _StreakBarSkeleton extends StatelessWidget {
  const _StreakBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.06),
        border: Border(
          bottom: BorderSide(color: AppTheme.primary.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          _Shimmer(width: 60, height: 14),
          const SizedBox(width: 12),
          Expanded(child: _Shimmer(height: 5)),
        ],
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({this.width, required this.height});
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(
          duration: 1200.ms,
          color: Colors.white24,
        );
  }
}

// ════════════════════════════════════════════════
// マイルストーン達成ダイアログ
// ════════════════════════════════════════════════
class _MilestoneDialog extends StatelessWidget {
  const _MilestoneDialog({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.days,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final int days;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primary.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.2),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 紙吹雪エフェクト代わりの装飾テキスト
            Text(
              '🎊 🎊 🎊',
              style: const TextStyle(fontSize: 24),
            ).animate(onPlay: (c) => c.repeat(period: 1.5.seconds))
                .shimmer(color: AppTheme.primary),

            const SizedBox(height: 16),

            Text(emoji, style: const TextStyle(fontSize: 72))
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                ),

            const SizedBox(height: 16),

            // 日数バッジ
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$days日連続達成！',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),

            const SizedBox(height: 16),

            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, height: 1.5),
            ).animate(delay: 500.ms).fadeIn(),

            const SizedBox(height: 28),

            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('やった！ 🙌', style: TextStyle(fontSize: 16)),
            ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
