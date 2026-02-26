import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/features/chat/providers/streak_provider.dart';
import 'package:rizzlang/features/chat/widgets/streak_bar.dart';

// StreakBar Widget テスト
// - loading 状態でスケルトン表示
// - streak=0 で「0日」表示
// - streak=7 で「7日」と🌟表示
void main() {
  Widget buildWithScope({required List<Override> overrides}) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(
        home: Scaffold(
          body: StreakBar(),
        ),
      ),
    );
  }

  group('StreakBar — loading 状態', () {
    testWidgets('loading 中はスケルトン（Container）が表示される', (tester) async {
      // streakDataProvider を永遠にローディング状態にする
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async {
                // 無限に待機 = loading 状態
                await Future<void>.delayed(const Duration(hours: 1));
                return const StreakData();
              },
            ),
          ],
        ),
      );

      // 最初のフレームを描画（loading 状態）
      await tester.pump();

      // スケルトン用の Container が描画されている
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });
  });

  group('StreakBar — streak=0', () {
    testWidgets('streak=0 のとき「0日」が表示される', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 0),
            ),
          ],
        ),
      );

      // データ取得完了まで待機
      await tester.pump();
      await tester.pump();

      expect(find.text('0日'), findsOneWidget);
    });
  });

  group('StreakBar — streak=7', () {
    testWidgets('streak=7 のとき「7日」が表示される', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 7),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('7日'), findsOneWidget);
    });

    testWidgets('streak=7 のとき🌟が表示される（7日以上のアイコン）', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 7),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      // streak >= 7 のとき🌟アイコンが表示される
      expect(find.text('🌟'), findsOneWidget);
    });
  });

  group('StreakBar — streak=30', () {
    testWidgets('streak=30 のとき👑が表示される', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 30),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('👑'), findsOneWidget);
    });
  });

  group('StreakBar — XP 表示', () {
    testWidgets('todayXp が 0 のとき XP バッジが非表示', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 3, todayXp: 0),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      // XP バッジテキストが存在しない
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('todayXp > 0 のとき XP バッジが表示される', (tester) async {
      await tester.pumpWidget(
        buildWithScope(
          overrides: [
            streakDataProvider.overrideWith(
              (ref) async => const StreakData(streak: 1, todayXp: 10),
            ),
          ],
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('+10 XP'), findsOneWidget);
    });
  });
}
