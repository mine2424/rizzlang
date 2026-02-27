// test/helpers/test_helpers.dart
//
// 共通テストユーティリティ
// - フェイクデータビルダー
// - テスト用 MaterialApp ラッパー
// - Riverpod プロバイダーオーバーライドヘルパー

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rizzlang/core/models/message_model.dart';
import 'package:rizzlang/core/theme/app_theme.dart';
import 'package:rizzlang/features/chat/providers/streak_provider.dart';
import 'package:rizzlang/features/chat/providers/chat_provider.dart';

// ────────────────────────────────────────────────
// フェイクデータビルダー
// ────────────────────────────────────────────────

/// テスト用 MessageModel（ユーザーメッセージ）
MessageModel fakeUserMessage({
  String id = 'test-user-1',
  String content = '会いたかった、今日何してた？',
  String? originalJapanese,
}) =>
    MessageModel(
      id: id,
      role: MessageRole.user,
      content: content,
      originalJapanese: originalJapanese,
      createdAt: DateTime(2026, 2, 26, 15, 30),
    );

/// テスト用 MessageModel（キャラクターメッセージ）
MessageModel fakeCharacterMessage({
  String id = 'test-char-1',
  String content = '오빠~ 오늘 카페 갔다왔어 ㅎㅎ 오빠도 보고 싶었어 ㅠㅠ',
}) =>
    MessageModel(
      id: id,
      role: MessageRole.character,
      content: content,
      createdAt: DateTime(2026, 2, 26, 15, 31),
    );

/// テスト用 GeneratedReply
GeneratedReply fakeGeneratedReply({
  String reply = '보고 싶었어~ 오늘 뭐 했어? 🥺',
  String why = '「会いたかった」は 보고 싶었어 が自然',
  List<SlangItem> slang = const [],
  String nextMessage = '나 오빠 생각하면서 있었어 ㅠ',
  bool phaseComplete = false,
  String? tensionPhase,
}) =>
    GeneratedReply(
      reply: reply,
      why: why,
      slang: slang.isEmpty
          ? [
              const SlangItem(word: 'ㅎㅎ', meaning: '笑い・陽気さを表すスラング'),
              const SlangItem(word: 'ㅠㅠ', meaning: '泣き顔・切ない感情'),
            ]
          : slang,
      nextMessage: nextMessage,
      phaseComplete: phaseComplete,
      tensionPhase: tensionPhase,
    );

/// テスト用 StreakData — ゼロ状態
StreakData fakeStreakDataZero() => const StreakData(
      streak: 0,
      todayXp: 0,
      weeklyVocab: 0,
    );

/// テスト用 StreakData — 7日連続・XP 20
StreakData fakeStreakData7() => const StreakData(
      streak: 7,
      todayXp: 20,
      weeklyVocab: 12,
      newMilestone: 7,
    );

/// テスト用 StreakData — 30日連続
StreakData fakeStreakData30() => const StreakData(
      streak: 30,
      todayXp: 30,
      weeklyVocab: 25,
      newMilestone: 30,
    );

/// テスト用 ChatState — 初期（メッセージなし）
ChatState fakeChatStateEmpty() => const ChatState(
      messages: [],
      isLoading: false,
      turnsRemaining: 3,
    );

/// テスト用 ChatState — メッセージあり
ChatState fakeChatStateWithMessages() => ChatState(
      messages: [
        fakeCharacterMessage(),
        fakeUserMessage(content: '일 했어 😊 나도 보고 싶었어~ 빨리 보고 싶다'),
        fakeCharacterMessage(content: '오빠~ 빨리 만나고 싶어!! 🥺'),
      ],
      lastReply: fakeGeneratedReply(),
      turnsRemaining: 2,
    );

/// テスト用 ChatState — 上限超過
ChatState fakeChatStateLimitExceeded() => const ChatState(
      messages: [],
      isLimitExceeded: true,
      turnsRemaining: 0,
    );

/// テスト用 ChatState — Tension friction フェーズ
ChatState fakeChatStateTension() => ChatState(
      messages: [fakeCharacterMessage(content: '... 오빠 왜 연락 늦게 했어 ㅠ')],
      tensionPhase: 'friction',
      turnsRemaining: 2,
    );

/// テスト用 ChatState — エラー状態
ChatState fakeChatStateError() => const ChatState(
      messages: [],
      error: 'AI生成に失敗しました',
      turnsRemaining: 3,
    );

// ────────────────────────────────────────────────
// テスト用 MaterialApp ラッパー
// ────────────────────────────────────────────────

/// ProviderScope + MaterialApp(dark theme) でウィジェットをラップ
Widget buildTestApp(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(body: child),
      debugShowCheckedModeBanner: false,
    ),
  );
}

/// ProviderScope + MaterialApp でフル Scaffold なしにウィジェットをラップ
Widget buildTestWidget(
  Widget child, {
  List<Override> overrides = const [],
  double width = 390,
  double height = 844,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppTheme.background,
        body: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    ),
  );
}

// ────────────────────────────────────────────────
// Riverpod プロバイダーオーバーライドヘルパー
// ────────────────────────────────────────────────

/// streakDataProvider を fake データでオーバーライド
Override overrideStreakWith(StreakData data) =>
    streakDataProvider.overrideWith((ref) async => data);

/// chatProvider を fake ChatState でオーバーライド
Override overrideChatWith(ChatState fakeState) =>
    chatProvider.overrideWith((ref) => _FakeChatNotifier(fakeState));

// ────────────────────────────────────────────────
// Fake ChatNotifier（テスト用）
// ────────────────────────────────────────────────
class _FakeChatNotifier extends StateNotifier<ChatState> {
  _FakeChatNotifier(ChatState initialState) : super(initialState);

  @override
  Future<void> generateReply(String userText, {bool isRetry = false}) async {
    // テスト用: 即座に返信をシミュレート
    final reply = fakeGeneratedReply();
    state = state.copyWith(
      messages: [
        ...state.messages,
        fakeUserMessage(content: '보고 싶었어~ 일 했어'),
        fakeCharacterMessage(content: reply.nextMessage),
      ],
      lastReply: reply,
      turnsRemaining: state.turnsRemaining > 0
          ? state.turnsRemaining - 1
          : state.turnsRemaining,
    );
  }

  void onInputChanged(String text) {}
  void retryLastMessage() {}
  void dismissRelationshipUp() => state = state.copyWith(showRelationshipUp: false);
  void onProUpgraded() => state = state.copyWith(isLimitExceeded: false, turnsRemaining: -1);
}
