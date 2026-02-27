import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/pronunciation_service.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_theme.dart';

/// メッセージテキストのロングタップで表示される発音ガイド BottomSheet。
///
/// 表示内容:
///   - 元テキスト（大きめ・外国語フォント）
///   - 📖 ローマ字読み
///   - 🔤 カタカナ読み（空でなければ）
///   - ベトナム語の場合: 声調ガイド一覧
///   - 🔊 声に出して聞くボタン（TtsService 連携）
class PronunciationGuideSheet extends ConsumerWidget {
  const PronunciationGuideSheet({
    super.key,
    required this.text,
    required this.language,
  });

  final String text;
  final String language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(pronunciationServiceProvider);
    final result = service.getGuide(text, language);
    final tts = ref.read(ttsServiceProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── ドラッグハンドル ─────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── 元テキスト ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.4,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),

          // ── ローマ字読み ─────────────────────────
          if (result.romanization.isNotEmpty &&
              result.romanization != text) ...[
            _GuideRow(
              emoji: '📖',
              label: 'ローマ字',
              value: result.romanization,
            ),
            const SizedBox(height: 10),
          ],

          // ── カタカナ読み ─────────────────────────
          if (result.katakana.isNotEmpty) ...[
            _GuideRow(
              emoji: '🔤',
              label: 'カタカナ',
              value: result.katakana,
            ),
            const SizedBox(height: 10),
          ],

          // ── ベトナム語 声調ガイド ─────────────────
          if (result.toneHints.isNotEmpty) ...[
            const SizedBox(height: 6),
            Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '🎵 声調ガイド',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...result.toneHints.map((hint) => _ToneHintTile(hint: hint)),
          ],

          const SizedBox(height: 20),

          // ── 🔊 TTS ボタン ─────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _TtsButton(
              onPressed: () async {
                await tts.speak(text, languageCode: language);
              },
            ),
          ),

          // ── セーフエリア余白 ─────────────────────
          SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// _GuideRow  — ローマ字 / カタカナ 行
// ════════════════════════════════════════════════
class _GuideRow extends StatelessWidget {
  const _GuideRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  final String emoji;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// _ToneHintTile  — ベトナム語声調リストアイテム
// ════════════════════════════════════════════════
class _ToneHintTile extends StatelessWidget {
  const _ToneHintTile({required this.hint});
  final ToneHint hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        children: [
          // 声調記号付き文字
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              hint.char,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ピッチ記号
          Text(
            hint.symbol,
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 10),
          // 名前 + 説明
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hint.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hint.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// _TtsButton  — 読み上げボタン
// ════════════════════════════════════════════════
class _TtsButton extends StatefulWidget {
  const _TtsButton({required this.onPressed});
  final Future<void> Function() onPressed;

  @override
  State<_TtsButton> createState() => _TtsButtonState();
}

class _TtsButtonState extends State<_TtsButton> {
  bool _speaking = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _speaking
            ? null
            : () async {
                setState(() => _speaking = true);
                try {
                  await widget.onPressed();
                } finally {
                  if (mounted) setState(() => _speaking = false);
                }
              },
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primary.withOpacity(0.9),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: _speaking
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Text('🔊', style: TextStyle(fontSize: 18)),
        label: Text(
          _speaking ? '読み上げ中...' : '声に出して聞く',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
