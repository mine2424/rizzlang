import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/message_model.dart';
import '../../../core/theme/app_theme.dart';

class ReplyPanel extends StatefulWidget {
  const ReplyPanel({super.key, required this.reply});
  final GeneratedReply reply;

  @override
  State<ReplyPanel> createState() => _ReplyPanelState();
}

class _ReplyPanelState extends State<ReplyPanel> {
  bool _isExpanded = true;
  bool _copied = false;

  Future<void> _copyReply() async {
    await Clipboard.setData(ClipboardData(text: widget.reply.reply));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
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
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 12, 8),
              child: Row(
                children: [
                  Text(
                    '✦ 解説',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Spacer(),
                  // コピーボタン
                  GestureDetector(
                    onTap: _copyReply,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _copied
                          ? Text(
                              'コピー済み ✓',
                              key: const ValueKey('copied'),
                              style: TextStyle(
                                  color: Colors.green, fontSize: 11),
                            )
                          : Row(
                              key: const ValueKey('copy'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy_rounded,
                                    size: 14, color: Colors.white38),
                                const SizedBox(width: 4),
                                Text('コピー',
                                    style: TextStyle(
                                        color: Colors.white38, fontSize: 11)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.white38,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── 展開コンテンツ ──
          if (_isExpanded) ...[
            // 韓国語返信（メイン）
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.25)),
                ),
                child: Text(
                  widget.reply.reply,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 200.ms)
                .slideY(begin: 0.1, end: 0),

            // なぜ解説
            if (widget.reply.why.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: _InfoRow(
                  badge: 'なぜ',
                  badgeColor: AppTheme.primary,
                  text: widget.reply.why,
                ),
              ).animate(delay: 50.ms).fadeIn(duration: 200.ms),

            // スラング
            ...widget.reply.slang.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: _InfoRow(
                  badge: 'スラング',
                  badgeColor: Colors.blue.shade300,
                  text: '${entry.value.word}   —   ${entry.value.meaning}',
                  wordHighlight: entry.value.word,
                ),
              ).animate(delay: ((entry.key + 1) * 60).ms).fadeIn(duration: 200.ms),
            ),

            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.badge,
    required this.badgeColor,
    required this.text,
    this.wordHighlight,
  });

  final String badge;
  final Color badgeColor;
  final String text;
  final String? wordHighlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: badgeColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: badgeColor.withOpacity(0.3)),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: badgeColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
