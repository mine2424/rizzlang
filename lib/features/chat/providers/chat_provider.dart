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
  final bool isLimitExceeded;     // 無料ユーザーの日次上限
  final int turnsRemaining;       // -1 = Pro（無制限）
  final String? error;
  final String? openingMessage;   // 今日のシナリオ opening

  // Tension フェーズ
  final String? tensionPhase;     // 'friction' | 'reconciliation' | null
  final bool showRelationshipUp;  // 仲直り完了アニメーション

  // 難易度エンジン用トラッキング（usage_logs に送信）
  final int editCount;   // このセッション内の編集回数
  final int retryCount;  // このセッション内のリトライ回数

  const ChatState({
    this.messages = const [],
    this.lastReply,
    this.isLoading = false,
    this.isGenerating = false,
    this.isLimitExceeded = false,
    this.turnsRemaining = 3,
    this.error,
    this.openingMessage,
    this.tensionPhase,
    this.showRelationshipUp = false,
    this.editCount = 0,
    this.retryCount = 0,
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
    String? tensionPhase,
    bool? showRelationshipUp,
    int? editCount,
    int? retryCount,
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
      tensionPhase: tensionPhase ?? this.tensionPhase,
      showRelationshipUp: showRelationshipUp ?? this.showRelationshipUp,
      editCount: editCount ?? this.editCount,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

// ────────────────────────────────────────────────
// Notifier
// ────────────────────────────────────────────────
class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final SupabaseClient _supabase;

  // 直前の入力テキスト（編集検知用）
  String _lastSubmittedText = '';

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

  /// 当日初回セッション: 地우の opening メッセージを表示
  Future<void> _initTodaySession(String userId) async {
    try {
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
  // 編集検知
  // ────────────────────────────────────────────────
  /// TextFieldのテキスト変更時に呼ぶ（編集回数トラッキング）
  /// 同じ入力が再編集された場合は edit_count をインクリメント
  void onInputChanged(String currentText) {
    // テキストを入力→クリア→再入力した場合を「編集」と見なす
    if (_lastSubmittedText.isNotEmpty &&
        currentText.isNotEmpty &&
        currentText != _lastSubmittedText) {
      // 積極的な編集検知は送信時に行うため、ここでは状態を保持するだけ
    }
  }

  // ────────────────────────────────────────────────
  // メッセージ送信 & AI返信生成
  // ────────────────────────────────────────────────
  Future<void> generateReply(String userText, {bool isRetry = false}) async {
    if (state.isLimitExceeded) return;

    // 編集回数検知: 前回送信テキストと異なるが空でない → 修正送信
    final wasEdited = _lastSubmittedText.isNotEmpty &&
        userText != _lastSubmittedText &&
        !isRetry;
    final currentEditCount = state.editCount + (wasEdited ? 1 : 0);
    final currentRetryCount = state.retryCount + (isRetry ? 1 : 0);
    _lastSubmittedText = userText;

    state = state.copyWith(
      isGenerating: true,
      error: null,
      showRelationshipUp: false,
      editCount: currentEditCount,
      retryCount: currentRetryCount,
    );

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
        userLevel: 1,         // TODO: users テーブルから取得
        userCallName: 'オッパ', // TODO: users テーブルから取得
        editCount: wasEdited ? 1 : 0,
        retryCount: isRetry ? 1 : 0,
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
      final newRemaining = reply.turnsRemaining ??
          (state.turnsRemaining > 0
              ? state.turnsRemaining - 1
              : state.turnsRemaining);

      state = state.copyWith(
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
        // Tension フェーズ
        tensionPhase: reply.tensionPhase,
        showRelationshipUp: reply.phaseComplete,
      );
    } on AIServiceException catch (e) {
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

  /// エラー時にリトライ
  Future<void> retryLastMessage() async {
    if (_lastSubmittedText.isEmpty) return;
    await generateReply(_lastSubmittedText, isRetry: true);
  }

  /// 仲直りアニメーション表示後にリセット
  void dismissRelationshipUp() {
    state = state.copyWith(showRelationshipUp: false);
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
