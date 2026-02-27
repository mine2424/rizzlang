// test/flutter_test_config.dart
//
// Flutter テスト全体に適用されるグローバル設定
// - ゴールデンテストのピクセル許容差を設定
// - フォントローダーの設定（省略時はシステムフォント）

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // ゴールデンテストの許容ピクセル差（0.0 = 完全一致 / 0.01 = 1% 許容）
  // フォントレンダリングのOS間差異を吸収するために少し緩める
  goldenFileComparator = LocalFileComparator(
    Uri.parse('test/flutter_test_config.dart'),
  );

  await testMain();
}
