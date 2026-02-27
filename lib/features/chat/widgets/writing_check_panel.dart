import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/theme/app_theme.dart';

class WritingCheckPanel extends StatelessWidget {
  const WritingCheckPanel({super.key, required this.result});
  final WritingCheckResult result;

  @override
  Widget build(BuildContext context) {
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
