import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/message_model.dart';
import '../../../core/providers/character_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'pronunciation_guide_sheet.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = message.role == MessageRole.user;
    final activeCharacter = ref.watch(activeCharacterProvider);
    // キャラクターの言語コード（デフォルト韓国語）
    final language = activeCharacter?.language ?? 'ko';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(radius: 14, child: Text('🌸')),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            // ロングタップで発音ガイドを表示（キャラクターのメッセージのみ）
            onLongPress: !isUser
                ? () => _showPronunciationPopover(context, message.content, language)
                : null,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primary : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  // キャラクターのメッセージにはロングタップ hint を表示
                  if (!isUser) ...[
                    const SizedBox(height: 4),
                    Text(
                      '長押しで発音ガイド',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.muted.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ロングタップ時に発音ガイド BottomSheet を表示
  void _showPronunciationPopover(
    BuildContext context,
    String text,
    String language,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PronunciationGuideSheet(
        text: text,
        language: language,
      ),
    );
  }
}
