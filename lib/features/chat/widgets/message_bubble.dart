import 'package:flutter/material.dart';
import '../../../core/models/message_model.dart';
import '../../../core/theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            const CircleAvatar(radius: 14, child: Text('🌸')),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? AppTheme.primary : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isUser ? 18 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 18),
              ),
            ),
            child: Text(
              message.content,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
