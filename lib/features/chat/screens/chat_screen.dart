import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/reply_panel.dart';
import '../widgets/streak_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    ref.listen(chatProvider, (prev, next) {
      if (next.messages.length != prev?.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primary.withOpacity(0.2),
              child: const Text('🌸', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('지우 (ジウ)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('🇰🇷 ソウル出身 · オンライン',
                    style: TextStyle(fontSize: 11, color: AppTheme.muted)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ストリークバー
          const StreakBar(),

          // チャットメッセージ一覧
          Expanded(
            child: chatState.isLoading && chatState.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return MessageBubble(message: message)
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideY(begin: 0.1, end: 0);
                    },
                  ),
          ),

          // AI返信パネル（生成結果表示）
          if (chatState.lastReply != null)
            ReplyPanel(reply: chatState.lastReply!),

          // 入力エリア
          _buildInputArea(chatState),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatState chatState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💬 言いたいことを日本語で',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.muted,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  maxLines: 3,
                  minLines: 1,
                  enabled: !chatState.isGenerating,
                  decoration: InputDecoration(
                    hintText: '例：会いたかったよ、今日何してた？',
                    hintStyle: TextStyle(color: AppTheme.muted, fontSize: 13),
                  ),
                  onSubmitted: (_) => _onGenerate(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: chatState.isGenerating ? null : _onGenerate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: chatState.isGenerating
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('✦ 変換', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onGenerate() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider.notifier).generateReply(text);
    _inputController.clear();
  }
}
