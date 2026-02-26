import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/core/models/message_model.dart';
import 'package:rizzlang/features/chat/widgets/message_bubble.dart';

// MessageBubble Widget テスト
// - ユーザーメッセージは右寄せ
// - キャラクターメッセージは左寄せ + CircleAvatar 表示
void main() {
  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          child: child,
        ),
      ),
    );
  }

  MessageModel makeMessage({required MessageRole role, String content = 'テストメッセージ'}) {
    return MessageModel(
      id: 'test-id',
      role: role,
      content: content,
      createdAt: DateTime(2026, 2, 26),
    );
  }

  group('MessageBubble — ユーザーメッセージ', () {
    testWidgets('ユーザーメッセージは右寄せ（MainAxisAlignment.end）', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: makeMessage(role: MessageRole.user)),
        ),
      );

      // Row が存在することを確認
      final rowFinder = find.byType(Row);
      expect(rowFinder, findsAtLeastNWidgets(1));

      // MainAxisAlignment.end の Row を確認
      final rows = tester.widgetList<Row>(rowFinder);
      final outerRow = rows.first;
      expect(outerRow.mainAxisAlignment, equals(MainAxisAlignment.end));
    });

    testWidgets('ユーザーメッセージには CircleAvatar が表示されない', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: makeMessage(role: MessageRole.user)),
        ),
      );

      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('ユーザーメッセージのコンテンツが表示される', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: makeMessage(role: MessageRole.user, content: 'こんにちは！')),
        ),
      );

      expect(find.text('こんにちは！'), findsOneWidget);
    });
  });

  group('MessageBubble — キャラクターメッセージ', () {
    testWidgets('キャラクターメッセージは左寄せ（MainAxisAlignment.start）', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: makeMessage(role: MessageRole.character)),
        ),
      );

      final rowFinder = find.byType(Row);
      expect(rowFinder, findsAtLeastNWidgets(1));

      final rows = tester.widgetList<Row>(rowFinder);
      final outerRow = rows.first;
      expect(outerRow.mainAxisAlignment, equals(MainAxisAlignment.start));
    });

    testWidgets('キャラクターメッセージには CircleAvatar が表示される', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(message: makeMessage(role: MessageRole.character)),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('キャラクターメッセージのコンテンツが表示される', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          MessageBubble(
            message: makeMessage(
              role: MessageRole.character,
              content: '안녕! 오빠 ㅎㅎ',
            ),
          ),
        ),
      );

      expect(find.text('안녕! 오빠 ㅎㅎ'), findsOneWidget);
    });
  });
}
