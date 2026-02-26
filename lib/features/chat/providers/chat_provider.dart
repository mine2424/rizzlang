import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/message_model.dart';
import '../../../core/services/ai_service.dart';

// ────────────────────────────────────────────────
// State
// ────────────────────────────────────────────────
class ChatState {
  final List<MessageModel> messages;
  final GeneratedReply? lastReply;
  final bool isLoading;
  final bool isGenerating;
  final bool isLimitExceeded;   // 無料ユーザーの日次上限
  final int turnsRemaining;     // -1 = Pro（無制限）
  final String? error;
  final String? openingMessage; // 今日のシナリオ opening

  const ChatState({
    this.messages = const [],
    this.lastReply,
    this.isLoading = false,
    this.isGenerating = false,
    this.isLimitExceeded = false,
    this.turnsRemaining = 3,
    this.error,
    this.openingMessage,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    GeneratedReply? lastReply,
    bool? isLoading,
    bool? isGenerating,
    bool? isLimitExceeded,
    int? turnsRemaining,
    String? error,
    String? openingMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      lastReply: lastReply ?? this.lastReply,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      isLimitExceeded: isLimitExceeded ?? this.isLimitExceeded,
      turnsRemaining: turnsRemaining ?? this.turnsRemaining,
      error: error ?? this.error,
      openingMessage: openingMessage ?? this.openingMessage,
    );
  }
}

// ────────────────────────────────────────────────
// Notifier
// ────────────────────────────────────────────────
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

        // 使用量チェック
        final usageRes = await _supabase
            .from('usage_logs')
            .select('turns_used')
            .eq('user_id', userId)
            .eq('date', today)
            .maybeSingle();
        final turnsUsed = (usageRes?['turns_used'] as int?) ?? 0;

        final userData = await _supabase
            .from('users')
            .select('plan')
            .eq('id', userId)
            .single();
        final isPro = userData['plan'] == 'pro';
        final remaining = isPro ? -1 : (3 - turnsUsed);

        state = state.copyWith(
          messages: messages,
          isLoading: false,
          turnsRemaining: remaining,
          isLimitExceeded: !isPro && remaining <= 0,
        );
      } else {
        await _initTodaySession(userId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 当日初回セッション: Edge Function経由でシナリオ取得
  Future<void> _initTodaySession(String userId) async {
    try {
      // シナリオの opening_message は Edge Function から返ってくる
      // 仮メッセージで待機表示してから更新する
      final openingMsg = MessageModel(
        id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
        role: MessageRole.character,
        content: '오빠, 오늘도 연락해줘서 좋아 🥺',
        createdAt: DateTime.now(),
      );
      state = state.copyWith(messages: [openingMsg], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // ────────────────────────────────────────────────
  // メッセージ送信 & AI返信生成
  // ────────────────────────────────────────────────
  Future<void> generateReply(String userText) async {
    // 上限チェック（UIでも弾くが二重チェック）
    if (state.isLimitExceeded) return;

    state = state.copyWith(isGenerating: true, error: null);

    // ユーザーメッセージを即時表示
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

      final reply = await _aiService.generateReply(
        userText: userText,
        conversationId: userId,
        history: state.messages.sublist(
          state.messages.length > 10 ? state.messages.length - 10 : 0,
        ),
        userLevel: 1, // TODO: users テーブルから取得
        userCallName: 'オッパ', // TODO: users テーブルから取得
      );

      // ユーザーの「変換後」メッセージ（韓国語）
      final sentMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        role: MessageRole.user,
        content: reply.reply,
        originalJapanese: userText,
        createdAt: DateTime.now(),
      );

      // 地우の次のメッセージ
      final jiuNextMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        role: MessageRole.character,
        content: reply.nextMessage,
        createdAt: DateTime.now(),
      );

      // turnsRemaining を更新
      final newRemaining = state.turnsRemaining > 0
          ? state.turnsRemaining - 1
          : state.turnsRemaining;

      state = state.copyWith(
        // 仮ユーザーメッセージを送信済みに差し替え
        messages: [
          ...state.messages.sublist(0, state.messages.length - 1),
          sentMessage,
          jiuNextMessage,
        ],
        lastReply: reply,
        isGenerating: false,
        turnsRemaining: newRemaining,
        isLimitExceeded: newRemaining == 0,
        openingMessage: reply.nextMessage,
      );
    } on AIServiceException catch (e) {
      // LIMIT_EXCEEDED を検出してペイウォールフラグを立てる
      if (e.statusCode == 429) {
        state = state.copyWith(
          isGenerating: false,
          isLimitExceeded: true,
          turnsRemaining: 0,
          messages: state.messages.sublist(0, state.messages.length - 1),
        );
      } else {
        state = state.copyWith(
          isGenerating: false,
          error: e.message,
          messages: state.messages.sublist(0, state.messages.length - 1),
        );
      }
    }
  }

  /// Pro アップグレード完了後に上限をリセット
  void onProUpgraded() {
    state = state.copyWith(isLimitExceeded: false, turnsRemaining: -1);
  }
}

// ────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final supabase = Supabase.instance.client;
  final aiService = AIService(supabase);
  return ChatNotifier(aiService, supabase);
});
