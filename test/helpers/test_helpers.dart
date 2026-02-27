// test/helpers/test_helpers.dart
//
// 共通テストユーティリティ
// - フェイクデータビルダー
// - テスト用 MaterialApp ラッパー
// - Riverpod プロバイダーオーバーライドヘルパー
// - FakeChatNotifier（Supabase 不要の ChatNotifier）

// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:rizzlang/core/models/message_model.dart';
import 'package:rizzlang/core/models/vocabulary_model.dart';
import 'package:rizzlang/core/providers/auth_provider.dart';
import 'package:rizzlang/core/services/ai_service.dart';
import 'package:rizzlang/core/theme/app_theme.dart';
import 'package:rizzlang/features/chat/providers/streak_provider.dart';
import 'package:rizzlang/features/chat/providers/chat_provider.dart';
import 'package:rizzlang/features/vocabulary/providers/vocabulary_provider.dart';

// ────────────────────────────────────────────────
// Mocktail モッククラス
// ────────────────────────────────────────────────

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockAIService extends Mock implements AIService {}

/// テスト用に Supabase と AIService をスタブ化した最小セットアップ
MockSupabaseClient createMockSupabase() {
  final mockSupabase = MockSupabaseClient();
  final mockAuth = MockGoTrueClient();
  when(() => mockSupabase.auth).thenReturn(mockAuth);
  when(() => mockAuth.currentUser).thenReturn(null);
  return mockSupabase;
}

// ────────────────────────────────────────────────
// FakeChatNotifier — ChatNotifier を正しく継承
// ────────────────────────────────────────────────

/// ChatNotifier.withState を使い Supabase 読み込みをスキップするテスト用 Notifier
class FakeChatNotifier extends ChatNotifier {
  FakeChatNotifier(ChatState initialState)
      : super.withState(
          MockAIService(),
          createMockSupabase(),
          initialState,
        );

  @override
  Future<void> generateReply(String userText, {bool isRetry = false}) async {
    // テスト用: 即座にフェイク返信をシミュレート
    final reply = fakeGeneratedReply();
    state = state.copyWith(
      messages: [
        ...state.messages,
        fakeUserMessage(content: '보고 싶었어~ 일 했어'),
        fakeCharacterMessage(content: reply.nextMessage),
      ],
      lastReply: reply,
      turnsRemaining:
          state.turnsRemaining > 0 ? state.turnsRemaining - 1 : state.turnsRemaining,
    );
  }
}

// ────────────────────────────────────────────────
// フェイクデータビルダー
// ────────────────────────────────────────────────

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

StreakData fakeStreakDataZero() => const StreakData();

StreakData fakeStreakData7() => const StreakData(
      streak: 7,
      todayXp: 20,
      weeklyVocab: 12,
      newMilestone: 7,
    );

StreakData fakeStreakData30() => const StreakData(
      streak: 30,
      todayXp: 30,
      weeklyVocab: 25,
      newMilestone: 30,
    );

ChatState fakeChatStateEmpty() => const ChatState(
      messages: [],
      isLoading: false,
      turnsRemaining: 3,
    );

ChatState fakeChatStateWithMessages() => ChatState(
      messages: [
        fakeCharacterMessage(),
        fakeUserMessage(content: '일 했어 😊 나도 보고 싶었어~'),
        fakeCharacterMessage(content: '오빠~ 빨리 만나고 싶어!! 🥺'),
      ],
      lastReply: fakeGeneratedReply(),
      turnsRemaining: 2,
    );

ChatState fakeChatStateLimitExceeded() => const ChatState(
      isLimitExceeded: true,
      turnsRemaining: 0,
    );

ChatState fakeChatStateTension() => ChatState(
      messages: [fakeCharacterMessage(content: '... 오빠 왜 연락 늦게 했어 ㅠ')],
      tensionPhase: 'friction',
      turnsRemaining: 2,
    );

ChatState fakeChatStateError() => const ChatState(
      error: 'AI生成に失敗しました',
      turnsRemaining: 3,
    );

// ────────────────────────────────────────────────
// テスト用アプリラッパー
// ────────────────────────────────────────────────

Widget buildTestApp(
  Widget child, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.dark,
      home: child,
      debugShowCheckedModeBanner: false,
    ),
  );
}

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
        body: SizedBox(width: width, height: height, child: child),
      ),
    ),
  );
}

// ────────────────────────────────────────────────
// プロバイダーオーバーライドヘルパー
// ────────────────────────────────────────────────

/// streakDataProvider を fakeデータでオーバーライド
Override overrideStreakWith(StreakData data) =>
    streakDataProvider.overrideWith((ref) async => data);

/// chatProvider を FakeChatNotifier（型安全）でオーバーライド
Override overrideChatWith(ChatState fakeState) =>
    chatProvider.overrideWith((ref) => FakeChatNotifier(fakeState));

/// supabaseClientProvider をモック SupabaseClient でオーバーライド
Override overrideSupabase() =>
    supabaseClientProvider.overrideWithValue(createMockSupabase());

/// vocabularyProvider を空リストでオーバーライド
Override overrideVocabEmpty() =>
    vocabularyProvider.overrideWith((ref) async => <VocabularyModel>[]);

/// テスト用に全プロバイダーをオーバーライドするデフォルトセット
List<Override> get defaultTestOverrides => [
      overrideSupabase(),
      overrideStreakWith(fakeStreakDataZero()),
      overrideChatWith(fakeChatStateEmpty()),
      overrideVocabEmpty(),
    ];
