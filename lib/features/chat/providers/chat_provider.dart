import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/message_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/character_provider.dart';
import '../../../core/services/ai_service.dart';
import '../../vocabulary/providers/vocabulary_provider.dart';

/// copyWith で nullable フィールドを null クリアするためのセンチネルクラス
class _Undefined {
  const _Undefined();
}

/// センチネルのデフォルト値（コンパイル時定数）
const _undefined = _Undefined();

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

  // ユーザー設定（Supabase から取得）
  final int userLevel;        // 1-4: AI難易度
  final String userCallName;  // 지우からの呼び方

  // シナリオ情報
  final String? scenarioDay;  // 例: "S1W1D3" (AppBar に表示)

  // キャラクター情報
  final String? characterId;  // アクティブキャラクターの UUID

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
    this.userLevel = 1,
    this.userCallName = 'オッパ',
    this.scenarioDay,
    this.characterId,
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
    // tensionPhase は null クリアも許可するため Object? + センチネルを使用
    Object? tensionPhase = _undefined,
    bool? showRelationshipUp,
    int? editCount,
    int? retryCount,
    int? userLevel,
    String? userCallName,
    String? scenarioDay,
    String? characterId,
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
      // _undefined の場合は既存値を維持、null が渡された場合は null にクリア
      tensionPhase: tensionPhase is _Undefined
          ? this.tensionPhase
          : tensionPhase as String?,
      showRelationshipUp: showRelationshipUp ?? this.showRelationshipUp,
      editCount: editCount ?? this.editCount,
      retryCount: retryCount ?? this.retryCount,
      userLevel: userLevel ?? this.userLevel,
      userCallName: userCallName ?? this.userCallName,
      scenarioDay: scenarioDay ?? this.scenarioDay,
      characterId: characterId ?? this.characterId,
    );
  }

// ────────────────────────────────────────────────
// Notifier
// ────────────────────────────────────────────────
class ChatNotifier extends StateNotifier<ChatState> {
  final AIService _aiService;
  final SupabaseClient _supabase;
  final String? _characterId;

  // 直前の入力テキスト（編集検知用）
  String _lastSubmittedText = '';

  ChatNotifier(this._aiService, this._supabase, {String? characterId})
      : _characterId = characterId,
        super(ChatState(characterId: characterId)) {
    _loadTodayConversation();
  }

  /// テスト用コンストラクタ — 初期ステートを直接注入し、Supabase 読み込みをスキップ
  @visibleForTesting
  ChatNotifier.withState(
    this._aiService,
    this._supabase,
    ChatState initialState,
  ) : _characterId = initialState.characterId,
        super(initialState);

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
            .select('plan, current_level, user_call_name')
            .eq('id', userId)
            .single();
        final isPro = userData['plan'] == 'pro';
        final remaining = isPro ? -1 : (3 - turnsUsed);

        state = state.copyWith(
          messages: messages,
          isLoading: false,
          turnsRemaining: remaining,
          isLimitExceeded: !isPro && remaining <= 0,
          userLevel: (userData['current_level'] as int?) ?? 1,
          userCallName: (userData['user_call_name'] as String?) ?? 'オッパ',
        );
      } else {
        await _initTodaySession(userId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 当日初回セッション: ユーザーデータ取得 + 지우の opening メッセージ表示
  Future<void> _initTodaySession(String userId) async {
    try {
      // ユーザー設定を取得
      final userData = await _supabase
          .from('users')
          .select('plan, current_level, user_call_name')
          .eq('id', userId)
          .maybeSingle();

      final callName = (userData?['user_call_name'] as String?) ?? 'オッパ';
      final level = (userData?['current_level'] as int?) ?? 1;
      final isPro = userData?['plan'] == 'pro';

      final openingMsg = MessageModel(
        id: 'opening_${DateTime.now().millisecondsSinceEpoch}',
        role: MessageRole.character,
        content: '$callName, 오늘도 연락해줘서 좋아 🥺',
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        messages: [openingMsg],
        isLoading: false,
        userLevel: level,
        userCallName: callName,
        turnsRemaining: isPro ? -1 : state.turnsRemaining,
        isLimitExceeded: !isPro && state.turnsRemaining <= 0,
      );
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
        userLevel: state.userLevel,
        userCallName: state.userCallName,
        characterId: _characterId ?? state.characterId,
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

      // 지우の次のメッセージ
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
        // シナリオ情報
        scenarioDay: reply.scenarioDay ?? state.scenarioDay,
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

  /// 仲直りアニメーション表示後にリセット（tensionPhase もクリア）
  void dismissRelationshipUp() {
    state = state.copyWith(
      showRelationshipUp: false,
      tensionPhase: null, // Tension フェーズ終了 → null クリア
    );
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
  // supabaseClientProvider 経由でテスト時のモック注入を可能にする
  final supabase = ref.watch(supabaseClientProvider);
  final aiService = ref.watch(aiServiceProvider);
  // アクティブキャラクターの ID を渡す（切り替え後は画面遷移で再生成）
  final activeCharacter = ref.watch(activeCharacterProvider);
  return ChatNotifier(aiService, supabase, characterId: activeCharacter?.id);
});
