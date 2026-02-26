import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/core/models/message_model.dart';
import 'package:rizzlang/features/chat/widgets/reply_panel.dart';

// ReplyPanel Widget テスト
// - デフォルトで展開状態
// - タップで折りたたみ → 再タップで展開
// - コピーボタンが存在する
void main() {
  GeneratedReply makeReply({
    String reply = '오빠 보고 싶었어 ㅠ',
    String why = '会いたかった気持ちを素直に表現',
    String nextMessage = '오늘 뭐 했어?',
    List<SlangItem> slang = const [],
  }) {
    return GeneratedReply(
      reply: reply,
      why: why,
      slang: slang,
      nextMessage: nextMessage,
    );
  }

  Widget buildTestable(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('ReplyPanel — デフォルト状態', () {
    testWidgets('デフォルトで展開状態（韓国語返信テキストが表示される）', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      // 返信テキストが表示されている（展開状態）
      expect(find.text('오빠 보고 싶었어 ㅠ'), findsOneWidget);
    });

    testWidgets('コピーボタンが存在する', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      // コピーテキスト or コピーアイコンが存在する
      expect(find.text('コピー'), findsOneWidget);
    });

    testWidgets('解説セクション（✦ 解説）が表示される', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      expect(find.text('✦ 解説'), findsOneWidget);
    });
  });

  group('ReplyPanel — 折りたたみ動作', () {
    testWidgets('タップで折りたたまれる（韓国語返信が非表示になる）', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      // 初期状態：展開されている
      expect(find.text('오빠 보고 싶었어 ㅠ'), findsOneWidget);

      // ✦ 解説 行をタップ → 折りたたむ
      await tester.tap(find.text('✦ 解説'));
      await tester.pumpAndSettle();

      // 折りたたまれた → 返信テキストが非表示
      expect(find.text('오빠 보고 싶었어 ㅠ'), findsNothing);
    });

    testWidgets('折りたたみ後に再タップで展開される', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      // 折りたたむ
      await tester.tap(find.text('✦ 解説'));
      await tester.pumpAndSettle();

      // 再展開
      await tester.tap(find.text('✦ 解説'));
      await tester.pumpAndSettle();

      // 展開された → 返信テキストが再表示
      expect(find.text('오빠 보고 싶었어 ㅠ'), findsOneWidget);
    });

    testWidgets('折りたたみ後もコピーボタンは存在する', (tester) async {
      await tester.pumpWidget(
        buildTestable(ReplyPanel(reply: makeReply())),
      );

      // 折りたたむ
      await tester.tap(find.text('✦ 解説'));
      await tester.pumpAndSettle();

      // コピーボタンはヘッダーに残っている
      expect(find.text('コピー'), findsOneWidget);
    });
  });

  group('ReplyPanel — slang 表示', () {
    testWidgets('slang が含まれる場合に単語が表示される', (tester) async {
      await tester.pumpWidget(
        buildTestable(
          ReplyPanel(
            reply: makeReply(
              slang: [
                const SlangItem(word: 'ㅠㅠ', meaning: '泣き顔・悲しい気持ち'),
              ],
            ),
          ),
        ),
      );

      expect(find.textContaining('ㅠㅠ'), findsAtLeastNWidgets(1));
    });
  });
}
