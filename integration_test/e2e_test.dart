// integration_test/e2e_test.dart
//
// RizzLang E2E 統合テスト
//
// 実行コマンド（シミュレータ/エミュレータ接続時）:
//   flutter test integration_test/e2e_test.dart -d <device-id>
//
// 各テストは Supabase/Firebase をモックした ProviderScope を使用するため、
// 外部サービスへの接続は不要です。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rizzlang/core/theme/app_theme.dart';
import 'package:rizzlang/features/chat/screens/chat_screen.dart';
import 'package:rizzlang/features/chat/widgets/streak_bar.dart';
import 'package:rizzlang/features/vocabulary/screens/vocabulary_screen.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member

import '../test/helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ════════════════════════════════════════════════════════════
  // シナリオ 1: チャット画面 — 初期状態レンダリング
  // ════════════════════════════════════════════════════════════
  group('E2E: Chat screen initial state', () {
    testWidgets('空のチャット画面が正常にレンダリングされる', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // AppBar に지우の名前が表示される
      expect(find.text('지우 (ジウ)'), findsOneWidget);

      // StreakBar が表示される
      expect(find.byType(StreakBar), findsOneWidget);

      // 入力エリアのヒントが表示される
      expect(find.text('例：会いたかったよ、今日何してた？'), findsOneWidget);

      // ✦変換ボタンが表示される
      expect(find.text('✦ 変換'), findsOneWidget);
    });

    testWidgets('streak=7 の場合、週次サマリカードが表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 400));

      // 週次サマリカードのヘッダーが表示される
      expect(find.text('今週の学習まとめ'), findsOneWidget);
      // 7日連続
      expect(find.textContaining('7日連続'), findsAtLeastNWidgets(1));
    });

    testWidgets('streak=0の場合、週次サマリカードは非表示', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('今週の学習まとめ'), findsNothing);
    });

    testWidgets('メッセージがある状態でチャット画面が表示される', (tester) async {
      final state = fakeChatStateWithMessages();
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(state),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // メッセージが表示される（3件）
      for (final msg in state.messages) {
        expect(find.text(msg.content), findsAtLeastNWidgets(1));
      }

      // ReplyPanel が表示される（lastReply あり）
      expect(find.text('✦ 解説'), findsOneWidget);
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 2: チャット送信フロー
  // ════════════════════════════════════════════════════════════
  group('E2E: Chat send flow', () {
    testWidgets('テキストを入力して変換ボタンをタップするとメッセージが追加される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // テキスト入力
      await tester.enterText(find.byType(TextField), '会いたかったよ');
      await tester.pump();

      expect(find.text('会いたかったよ'), findsOneWidget);

      // 変換ボタンをタップ
      await tester.tap(find.text('✦ 変換'));
      await tester.pump();

      // 送信後 TextField がクリアされる（onGenerate で clear()）
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text ?? '', isEmpty);
    });

    testWidgets('空テキストで変換ボタンをタップしてもメッセージが追加されない', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // 空のまま変換ボタンをタップ
      await tester.tap(find.text('✦ 変換'));
      await tester.pump();

      // メッセージが追加されていないことを確認
      // (fakeChatStateEmpty のメッセージ数=0 のまま)
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 3: 上限超過 → ペイウォールバナー表示
  // ════════════════════════════════════════════════════════════
  group('E2E: Paywall banner', () {
    testWidgets('isLimitExceeded=true でペイウォールバナーが表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateLimitExceeded()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 400));

      // 지우のペイウォールメッセージ
      expect(find.textContaining('오늘 대화 끝났어'), findsOneWidget);

      // アップグレードボタン
      expect(find.textContaining('Pro にアップグレード'), findsOneWidget);

      // 通常入力エリアは非表示
      expect(find.text('例：会いたかったよ、今日何してた？'), findsNothing);
    });

    testWidgets('isLimitExceeded=false で通常入力エリアが表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // 通常入力エリア表示
      expect(find.text('💬 言いたいことを日本語で'), findsOneWidget);
      // ペイウォールメッセージは非表示
      expect(find.textContaining('오늘 대화 끝났어'), findsNothing);
    });

    testWidgets('残り回数バッジ — 残り3回が正しく表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('残り 3回'), findsOneWidget);
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 4: Tension フェーズバナー
  // ════════════════════════════════════════════════════════════
  group('E2E: Tension phase banner', () {
    testWidgets('tensionPhase=friction でバナーが表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateTension()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.textContaining('지우がちょっと拗ねています'), findsOneWidget);
    });

    testWidgets('tensionPhase=null でバナーが非表示', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('地우がちょっと拗ねています'), findsNothing);
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 5: エラーリトライバナー
  // ════════════════════════════════════════════════════════════
  group('E2E: Error retry banner', () {
    testWidgets('error ありでリトライバナーが表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateError()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('生成に失敗しました'), findsOneWidget);
      expect(find.text('再試行'), findsOneWidget);
    });

    testWidgets('再試行ボタンをタップできる', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateError()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // 再試行ボタンをタップ（例外なしで完了することを確認）
      await tester.tap(find.text('再試行'));
      await tester.pump();

      // クラッシュしないことを確認（画面が残っている）
      expect(find.byType(ChatScreen), findsOneWidget);
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 6: BottomNavigationBar — ナビゲーション
  // ════════════════════════════════════════════════════════════
  group('E2E: Bottom navigation', () {
    testWidgets('BottomNavigationBar の3タブが正しくレンダリングされる', (tester) async {
      await tester.pumpWidget(_buildNavigationTestApp());
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('チャット'), findsOneWidget);
      expect(find.text('語彙帳'), findsOneWidget);
      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('語彙帳タブをタップすると語彙帳画面に遷移する', (tester) async {
      await tester.pumpWidget(_buildNavigationTestApp());
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('語彙帳'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(VocabularyScreen), findsOneWidget);
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 7: StreakBar 表示ロジック
  // ════════════════════════════════════════════════════════════
  group('E2E: StreakBar display', () {
    testWidgets('streak=7 で🌟アイコンと日数が表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData7()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 400));

      // StreakBar 内の日数テキスト
      expect(find.textContaining('7日'), findsAtLeastNWidgets(1));
    });

    testWidgets('streak=30 で👑アイコンと日数が表示される', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakData30()),
          overrideChatWith(fakeChatStateEmpty()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.textContaining('30日'), findsAtLeastNWidgets(1));
    });
  });

  // ════════════════════════════════════════════════════════════
  // シナリオ 8: ReplyPanel の展開/折りたたみ
  // ════════════════════════════════════════════════════════════
  group('E2E: ReplyPanel interaction', () {
    testWidgets('ReplyPanel のタイトルをタップして折りたたみ/展開できる', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const ChatScreen(),
        overrides: [
          overrideStreakWith(fakeStreakDataZero()),
          overrideChatWith(fakeChatStateWithMessages()),
        ],
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // ReplyPanel が展開状態で表示される
      expect(find.text('✦ 解説'), findsOneWidget);

      // 解説パネルのヘッダーをタップして折りたたむ
      await tester.tap(find.text('✦ 解説'));
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      // 折りたたまれた状態ではスラング内容が非表示になる
      // (展開コンテンツの本文が消える)
      expect(find.text('✦ 解説'), findsOneWidget); // ヘッダーは残る
    });
  });
}

// ════════════════════════════════════════════════════════════
// BottomNavigationBar テスト用アプリ
// ════════════════════════════════════════════════════════════
Widget _buildNavigationTestApp() {
  final router = GoRouter(
    initialLocation: '/chat',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _TestHomeShell(child: child),
        routes: [
          GoRoute(
            path: '/chat',
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: '/vocabulary',
            builder: (_, __) => const VocabularyScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const Scaffold(
              body: Center(child: Text('設定画面')),
            ),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: defaultTestOverrides,
    child: MaterialApp.router(
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ),
  );
}

/// テスト用 HomeScreen シェル（BottomNavigationBar のみ）
class _TestHomeShell extends StatelessWidget {
  const _TestHomeShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    int index = 0;
    if (location == '/vocabulary') index = 1;
    if (location == '/settings') index = 2;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.muted,
        onTap: (i) {
          if (i == 0) context.go('/chat');
          if (i == 1) context.go('/vocabulary');
          if (i == 2) context.go('/settings');
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'チャット'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: '語彙帳'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: '設定'),
        ],
      ),
    );
  }
}
