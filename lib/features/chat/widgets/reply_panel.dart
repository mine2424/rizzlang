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
                          ? const Text(
                              'コピー済み ✓',
                              key: ValueKey('copied'),
                              style: TextStyle(
                                  color: Colors.green, fontSize: 11),
                            )
                          : const Row(
                              key: ValueKey('copy'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy_rounded,
                                    size: 14, color: Colors.white38),
                                SizedBox(width: 4),
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
            // 外国語返信（メイン）
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

            // なぜ解説 — primaryGlow 背景ストリップ
            if (widget.reply.why.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: AppTheme.primaryGlow,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 「なぜ」ピルバッジ
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.borderGlow),
                      ),
                      child: const Text(
                        'なぜ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.reply.why,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.text2,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 50.ms).fadeIn(duration: 200.ms),

            // スラング
            if (widget.reply.slang.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.reply.slang
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildSlangBadge(
                          entry.value.word,
                          entry.value.meaning,
                        ).animate(
                          delay: ((entry.key + 1) * 60).ms,
                        ).fadeIn(duration: 200.ms),
                      )
                      .toList(),
                ),
              ),

            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildSlangBadge(String word, String meaning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 11.5),
          children: [
            TextSpan(
              text: word,
              style: const TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: '  $meaning',
              style: const TextStyle(color: AppTheme.text2),
            ),
          ],
        ),
      ),
    );
  }
}
