import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final character = ref.watch(activeCharacterProvider);
    final language = character?.language ?? 'ko';

    return Padding(
      padding: EdgeInsets.only(
        top: 3,
        bottom: 3,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            // キャラクターアバター
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.surface2,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderGlow, width: 1.5),
              ),
              child: Center(
                child: Text(
                  character?.flagEmoji ?? '🌸',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: !isUser
                  ? () => _showPronunciationSheet(context, language)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: isUser ? AppTheme.primaryGradient : null,
                  color: isUser ? null : AppTheme.surface2,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border: isUser
                      ? null
                      : Border.all(color: AppTheme.border),
                  boxShadow: isUser
                      ? AppTheme.primaryShadow
                      : AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.55,
                        color: isUser ? Colors.white : AppTheme.text1,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser
                                ? Colors.white.withOpacity(0.5)
                                : AppTheme.text3,
                          ),
                        ),
                        if (!isUser) ...[
                          const SizedBox(width: 6),
                          Text(
                            '長押しで発音',
                            style: TextStyle(
                              fontSize: 9,
                              color: AppTheme.text3.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.05, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _showPronunciationSheet(BuildContext context, String language) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PronunciationGuideSheet(
        text: message.content,
        language: language,
      ),
    );
  }
}
