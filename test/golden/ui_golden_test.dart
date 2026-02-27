// test/golden/ui_golden_test.dart
//
// Visual Regression Tests (VRT) — Golden File Tests
//
// 初回実行時（ゴールデンファイル生成）:
//   flutter test test/golden/ --update-goldens
//
// 以降の実行（差分チェック）:
//   flutter test test/golden/
//
// ゴールデン画像の保存先: test/goldens/
// CI で差分が出た場合は PR のコメントに添付して目視確認を行う

// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/core/models/message_model.dart';
import 'package:rizzlang/core/theme/app_theme.dart';
import 'package:rizzlang/features/chat/widgets/message_bubble.dart';
import 'package:rizzlang/features/chat/widgets/reply_panel.dart';
import 'package:rizzlang/features/chat/widgets/streak_bar.dart';
import 'package:rizzlang/features/chat/screens/chat_screen.dart';

import '../helpers/test_helpers.dart';

// ══════════════════════════════════════════════════════════════════
// ゴールデンテスト共通設定
// ══════════════════════════════════════════════════════════════════

/// 固定サイズの Surface でウィジェットをキャプチャ
Future<void> captureGolden(
  WidgetTester tester,
  Widget widget,
  String goldenName, {
  double width = 390,
  double height = 200,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppTheme.background,
          body: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: widget,
            ),
          ),
        ),
      ),
    ),
  );
  // アニメーション初期フレームを解決
  await tester.pump(const Duration(milliseconds: 300));

  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$goldenName.png'),
  );
}

// ══════════════════════════════════════════════════════════════════
// MessageBubble ゴールデンテスト
// ══════════════════════════════════════════════════════════════════
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VRT: MessageBubble', () {
    testWidgets('01_message_bubble_user', (tester) async {
      await captureGolden(
        tester,
        MessageBubble(message: fakeUserMessage()),
        '01_message_bubble_user',
        height: 100,
      );
    });

    testWidgets('02_message_bubble_character', (tester) async {
      await captureGolden(
        tester,
        MessageBubble(message: fakeCharacterMessage()),
        '02_message_bubble_character',
        height: 120,
      );
    });

    testWidgets('03_message_bubble_user_with_japanese', (tester) async {
      await captureGolden(
        tester,
        MessageBubble(
          message: fakeUserMessage(
            content: '일 했어 😊 나도 보고 싶었어~',
            originalJapanese: '仕事してたよ、俺も会いたかった',
          ),
        ),
        '03_message_bubble_user_with_japanese',
        height: 120,
      );
    });

    testWidgets('04_message_bubble_long_content', (tester) async {
      await captureGolden(
        tester,
        MessageBubble(
          message: fakeCharacterMessage(
            content:
                '오빠~ 오늘 카페에서 공부하다가 오빠 생각났어 ㅎㅎ 왜냐면 오빠가 좋아하는 노래 나왔거든 ㅠㅠ 빨리 보고 싶다',
          ),
        ),
        '04_message_bubble_long_content',
        height: 160,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // ReplyPanel ゴールデンテスト
  // ══════════════════════════════════════════════════════════════════
  group('VRT: ReplyPanel', () {
    testWidgets('05_reply_panel_expanded', (tester) async {
      await captureGolden(
        tester,
        ReplyPanel(reply: fakeGeneratedReply()),
        '05_reply_panel_expanded',
        height: 260,
      );
    });

    testWidgets('06_reply_panel_expanded_no_slang', (tester) async {
      await captureGolden(
        tester,
        ReplyPanel(
          reply: fakeGeneratedReply(slang: []),
        ),
        '06_reply_panel_expanded_no_slang',
        height: 180,
      );
    });

    testWidgets('07_reply_panel_expanded_many_slang', (tester) async {
      await captureGolden(
        tester,
        ReplyPanel(
          reply: fakeGeneratedReply(
            slang: [
              const SlangItem(word: 'ㅎㅎ', meaning: '笑い・陽気さ'),
              const SlangItem(word: 'ㅠㅠ', meaning: '泣き顔・切ない感情'),
              const SlangItem(word: '대박', meaning: 'すごい・やばい（驚嘆）'),
            ],
          ),
        ),
        '07_reply_panel_expanded_many_slang',
        height: 310,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // StreakBar ゴールデンテスト
  // ══════════════════════════════════════════════════════════════════
  group('VRT: StreakBar', () {
    testWidgets('08_streak_bar_zero', (tester) async {
      await captureGolden(
        tester,
        const StreakBar(),
        '08_streak_bar_zero',
        height: 60,
        overrides: [overrideStreakWith(fakeStreakDataZero())],
      );
    });

    testWidgets('09_streak_bar_7days_hot', (tester) async {
      await captureGolden(
        tester,
        const StreakBar(),
        '09_streak_bar_7days_hot',
        height: 60,
        overrides: [overrideStreakWith(fakeStreakData7())],
      );
    });

    testWidgets('10_streak_bar_30days_crown', (tester) async {
      await captureGolden(
        tester,
        const StreakBar(),
        '10_streak_bar_30days_crown',
        height: 60,
        overrides: [overrideStreakWith(fakeStreakData30())],
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // TurnsRemainingBadge ゴールデンテスト
  // ══════════════════════════════════════════════════════════════════
  group('VRT: TurnsRemainingBadge', () {
    testWidgets('11_turns_remaining_3', (tester) async {
      await captureGolden(
        tester,
        _TestTurnsRemainingBadge(remaining: 3),
        '11_turns_remaining_3',
        height: 60,
        width: 200,
      );
    });

    testWidgets('12_turns_remaining_1_warning', (tester) async {
      await captureGolden(
        tester,
        _TestTurnsRemainingBadge(remaining: 1),
        '12_turns_remaining_1_warning',
        height: 60,
        width: 200,
      );
    });

    testWidgets('13_turns_remaining_0_upgrade', (tester) async {
      await captureGolden(
        tester,
        _TestTurnsRemainingBadge(remaining: 0),
        '13_turns_remaining_0_upgrade',
        height: 60,
        width: 200,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // TensionPhaseBanner ゴールデンテスト
  // ══════════════════════════════════════════════════════════════════
  group('VRT: TensionPhaseBanner', () {
    testWidgets('14_tension_banner_friction', (tester) async {
      await captureGolden(
        tester,
        const _TestTensionBanner(phase: 'friction'),
        '14_tension_banner_friction',
        height: 50,
      );
    });

    testWidgets('15_tension_banner_reconciliation', (tester) async {
      await captureGolden(
        tester,
        const _TestTensionBanner(phase: 'reconciliation'),
        '15_tension_banner_reconciliation',
        height: 50,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // WeeklySummaryCard ゴールデンテスト（ChatScreen 内）
  // ══════════════════════════════════════════════════════════════════
  group('VRT: WeeklySummaryCard', () {
    testWidgets('16_weekly_summary_card_with_data', (tester) async {
      await captureGolden(
        tester,
        const _TestWeeklySummaryCard(),
        '16_weekly_summary_card_with_data',
        height: 140,
        overrides: [overrideStreakWith(fakeStreakData7())],
      );
    });

    testWidgets('17_weekly_summary_card_zero', (tester) async {
      await captureGolden(
        tester,
        const _TestWeeklySummaryCard(),
        '17_weekly_summary_card_zero',
        height: 60,
        overrides: [overrideStreakWith(fakeStreakDataZero())],
      );
    });

    testWidgets('18_weekly_summary_card_30days', (tester) async {
      await captureGolden(
        tester,
        const _TestWeeklySummaryCard(),
        '18_weekly_summary_card_30days',
        height: 160,
        overrides: [overrideStreakWith(fakeStreakData30())],
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════
  // ChatScreen 全体（各状態のスクリーンショット）
  // ══════════════════════════════════════════════════════════════════
  group('VRT: ChatScreen (full)', () {
    testWidgets('19_chat_screen_empty', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/19_chat_screen_empty.png'),
      );
      addTearDown(() => tester.view.reset());
    });

    testWidgets('20_chat_screen_with_messages', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(fakeChatStateWithMessages()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/20_chat_screen_with_messages.png'),
      );
    });

    testWidgets('21_chat_screen_limit_exceeded', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateLimitExceeded()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/21_chat_screen_limit_exceeded.png'),
      );
    });

    testWidgets('22_chat_screen_tension_friction', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(fakeChatStateTension()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/22_chat_screen_tension_friction.png'),
      );
    });

    testWidgets('23_chat_screen_error_retry', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateError()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/23_chat_screen_error_retry.png'),
      );
    });
  });
}

// ══════════════════════════════════════════════════════════════════
// テスト用プライベートウィジェット
// ══════════════════════════════════════════════════════════════════

/// TurnsRemainingBadge をテスト用に公開
class _TestTurnsRemainingBadge extends StatelessWidget {
  const _TestTurnsRemainingBadge({required this.remaining});
  final int remaining;

  @override
  Widget build(BuildContext context) {
    final isEmpty = remaining <= 0;
    final primaryColor = AppTheme.primary;
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isEmpty
              ? primaryColor.withOpacity(0.15)
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEmpty ? primaryColor.withOpacity(0.5) : Colors.white12,
          ),
        ),
        child: Text(
          isEmpty ? '⚡ アップグレード' : '残り ${remaining}回',
          style: TextStyle(
            fontSize: 11,
            color: isEmpty ? primaryColor : Colors.white54,
            fontWeight: isEmpty ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// TensionPhaseBanner を公開
class _TestTensionBanner extends StatelessWidget {
  const _TestTensionBanner({required this.phase});
  final String phase;

  @override
  Widget build(BuildContext context) {
    final isFriction = phase == 'friction';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: (isFriction ? Colors.red : Colors.pink).withOpacity(0.12),
      child: Row(
        children: [
          Text(isFriction ? '😤' : '💕', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isFriction
                  ? '지우がちょっと拗ねています... 優しい言葉をかけよう'
                  : '仲直りチャンス！감사하다고 전해봐요 💕',
              style: TextStyle(
                color: isFriction ? Colors.red[300] : Colors.pink[300],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// WeeklySummaryCard をテスト用に公開（streak_provider をオーバーライドして使用）
class _TestWeeklySummaryCard extends ConsumerWidget {
  const _TestWeeklySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakDataProvider);
    return streakAsync.when(
      loading: () => const SizedBox(height: 8),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        if (data.streak == 0 && data.weeklyVocab == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'まだ記録なし',
              style: TextStyle(color: AppTheme.muted, fontSize: 12),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.12),
                AppTheme.primary.withOpacity(0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('📊', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    '今週の学習まとめ',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _Chip('${data.streak >= 30 ? "👑" : data.streak >= 7 ? "🌟" : "🔥"} ${data.streak}日連続'),
                  if (data.weeklyVocab > 0) _Chip('📖 +${data.weeklyVocab}表現'),
                  if (data.todayXp > 0) _Chip('⚡ +${data.todayXp}XP'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _Chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}
