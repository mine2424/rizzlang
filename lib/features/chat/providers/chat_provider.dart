import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/message_model.dart';
import '../../../core/services/ai_service.dart';

class ChatState {
  final List<MessageModel> messages;
  final GeneratedReply? lastReply;
  final bool isLoading;
  final bool isGenerating;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.lastReply,
    this.isLoading = false,
    this.isGenerating = false,
    this.error,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    GeneratedReply? lastReply,
    bool? isLoading,
    bool? isGenerating,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      lastReply: lastReply ?? this.lastReply,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error ?? this.error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final SupabaseClient _supabase;

  ChatNotifier(this._aiService, this._supabase) : super(const ChatState()) {
    _loadTodayConversation();
  }

  Future<void> _loadTodayConversation() async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .eq('date', today)
          .maybeSingle();

      if (response != null) {
        final rawMessages = response['messages'] as List;
        final messages = rawMessages
            .map((m) => MessageModel.fromJson(m as Map<String, dynamic>))
            .toList();
        state = state.copyWith(messages: messages, isLoading: false);
      } else {
        // 今日の初回 → シナリオから地우のオープニングメッセージを取得
        await _loadTodayScenario(userId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _loadTodayScenario(String userId) async {
    // TODO: ScenarioService からシーン取得してオープニングメッセージを表示
    // 仮実装: デフォルトメッセージ
    final openingMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.character,
      content: 'オッパ、오늘 뭐 했어? 🥺 나 보고 싶었어~',
      createdAt: DateTime.now(),
    );
    state = state.copyWith(
      messages: [openingMessage],
      isLoading: false,
    );
  }

  Future<void> generateReply(String userText) async {
    state = state.copyWith(isGenerating: true, error: null);

    // ユーザーの入力を仮表示
    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.user,
      content: userText,
      originalJapanese: userText,
      createdAt: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, userMessage]);

    try {
      final userId = _supabase.auth.currentUser?.id ?? '';
      final userData = await _supabase
          .from('users')
          .select('current_level, user_call_name')
          .eq('id', userId)
          .single();

      final reply = await _aiService.generateReply(
        userText: userText,
        conversationId: userId, // TODO: 実際のconversationId
        history: state.messages,
        userLevel: userData['current_level'] as int,
        userCallName: userData['user_call_name'] as String,
      );

      // 韓国語返信を送信済みとして追加
      final replyMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: MessageRole.user,
        content: reply.reply,
        originalJapanese: userText,
        createdAt: DateTime.now(),
      );

      // 地우の次のメッセージ
      final nextJiuMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        role: MessageRole.character,
        content: reply.nextMessage,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [
          // ユーザーの仮メッセージを生成済みに置き換え
          ...state.messages.sublist(0, state.messages.length - 1),
          replyMessage,
          nextJiuMessage,
        ],
        lastReply: reply,
        isGenerating: false,
      );

      // TODO: Supabaseに会話を保存
    } on AIServiceException catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: e.message,
        // ユーザーメッセージを取り消す
        messages: state.messages.sublist(0, state.messages.length - 1),
      );
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final supabase = Supabase.instance.client;
  final aiService = AIService(supabase);
  return ChatNotifier(aiService, supabase);
});
