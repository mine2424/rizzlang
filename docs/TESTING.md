# RizzLang テスト戦略ドキュメント

> 「リッチな UI がちゃんと動いているか」を自動で確認するための仕組み

---

## テスト全体像

```
test/
├── unit/                      # ユニットテスト（ロジック単体）
│   ├── difficulty_engine_test.dart   # 難易度エンジン境界値 (8件)
│   ├── srs_schedule_test.dart        # SM-2 SRS アルゴリズム (9件)
│   └── streak_logic_test.dart        # ストリーク管理ロジック (10件)
│
├── widget/                    # ウィジェットテスト（コンポーネント動作）
│   ├── message_bubble_test.dart      # MessageBubble 配置・表示 (6件)
│   ├── reply_panel_test.dart         # ReplyPanel 展開/折りたたみ (6件)
│   └── streak_bar_test.dart          # StreakBar 状態表示 (6件)
│
├── golden/                    # VRT ゴールデンテスト (23件)
│   └── ui_golden_test.dart
│
├── goldens/                   # ゴールデンファイル（自動生成・要コミット）
│   ├── 01_message_bubble_user.png
│   ├── 02_message_bubble_character.png
│   └── ... (計23ファイル)
│
└── helpers/
    └── test_helpers.dart      # 共通ヘルパー・フェイクデータ

integration_test/
├── e2e_test.dart              # E2E 統合テスト（8シナリオ・30件）
└── app_test.dart              # レガシースタブ（参照用）
```

---

## 各テスト種別の役割

| 種別 | 何を確認するか | 実行速度 | CI 必須 |
|------|--------------|---------|---------|
| **Unit** | ロジックの正確さ（境界値・エッジケース） | ⚡ 高速 | ✅ |
| **Widget** | コンポーネントの動作（タップ・表示・状態変化） | ⚡ 高速 | ✅ |
| **Golden (VRT)** | UI の見た目が変わっていないか | 🔶 中速 | ✅ |
| **E2E** | ユーザーフローが正常に動くか（モック使用） | 🔶 中速 | ✅ |

---

## コマンドリファレンス

```bash
# ユニット + ウィジェットテスト（全て）
flutter test

# 特定ファイル
flutter test test/unit/difficulty_engine_test.dart
flutter test test/widget/message_bubble_test.dart

# ゴールデンファイル生成（初回 or UI 変更後）
flutter test test/golden/ --update-goldens

# ゴールデン差分チェック
flutter test test/golden/

# E2E テスト（接続デバイス必須）
flutter test integration_test/e2e_test.dart -d <device-id>

# カバレッジ計測
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## VRT (Visual Regression Testing) ゴールデンテスト

### 仕組み

```
初回実行 (--update-goldens)
  ↓
ウィジェットを PNG としてキャプチャ
  ↓
test/goldens/ にファイルを保存
  ↓
以降の実行でピクセル比較
  ↓
差分があれば テスト FAIL
```

### キャプチャ対象（23パターン）

| # | ファイル名 | 対象ウィジェット | 状態 |
|---|-----------|----------------|------|
| 01 | `message_bubble_user` | MessageBubble | ユーザーメッセージ |
| 02 | `message_bubble_character` | MessageBubble | キャラクターメッセージ |
| 03 | `message_bubble_user_with_japanese` | MessageBubble | 日本語原文付き |
| 04 | `message_bubble_long_content` | MessageBubble | 長文 |
| 05 | `reply_panel_expanded` | ReplyPanel | 展開（スラング2件）|
| 06 | `reply_panel_expanded_no_slang` | ReplyPanel | 展開（スラングなし）|
| 07 | `reply_panel_expanded_many_slang` | ReplyPanel | 展開（スラング3件）|
| 08 | `streak_bar_zero` | StreakBar | 0日連続 |
| 09 | `streak_bar_7days_hot` | StreakBar | 7日連続・XP 20 |
| 10 | `streak_bar_30days_crown` | StreakBar | 30日連続・👑 |
| 11 | `turns_remaining_3` | TurnsRemainingBadge | 残り3回 |
| 12 | `turns_remaining_1_warning` | TurnsRemainingBadge | 残り1回 |
| 13 | `turns_remaining_0_upgrade` | TurnsRemainingBadge | 上限（⚡アップグレード）|
| 14 | `tension_banner_friction` | TensionPhaseBanner | 摩擦フェーズ |
| 15 | `tension_banner_reconciliation` | TensionPhaseBanner | 仲直りフェーズ |
| 16 | `weekly_summary_card_with_data` | WeeklySummaryCard | データあり（7日）|
| 17 | `weekly_summary_card_zero` | WeeklySummaryCard | データなし |
| 18 | `weekly_summary_card_30days` | WeeklySummaryCard | 30日連続 |
| 19 | `chat_screen_empty` | ChatScreen | 初期状態（フル画面）|
| 20 | `chat_screen_with_messages` | ChatScreen | メッセージ+解説パネル |
| 21 | `chat_screen_limit_exceeded` | ChatScreen | ペイウォールバナー |
| 22 | `chat_screen_tension_friction` | ChatScreen | Tensionバナー表示 |
| 23 | `chat_screen_error_retry` | ChatScreen | エラー+再試行バナー |

### UI 変更後の手順

1. UI を変更する
2. `flutter test test/golden/ --update-goldens` でゴールデンを更新
3. **目視確認**（`test/goldens/` の差分画像を確認）
4. 意図した変更であれば `git add test/goldens/` してコミット

> ⚠️ ゴールデンファイルは必ずコミットすること。ファイルなしでは CI が失敗する。

---

## E2E 統合テスト

### テストシナリオ一覧（8グループ・30件）

| グループ | シナリオ |
|---------|---------|
| **1. 初期状態** | 画面レンダリング / StreakBar / 週次サマリカード表示条件 |
| **2. 送信フロー** | テキスト入力→送信→クリア / 空送信は無効 |
| **3. ペイウォール** | 上限超過バナー表示 / 通常入力エリア表示 / 残り回数バッジ |
| **4. Tension フェーズ** | friction バナー表示 / tension=null で非表示 |
| **5. エラーリトライ** | エラーバナー表示 / 再試行ボタン動作 |
| **6. ナビゲーション** | BottomNav 3タブ表示 / 語彙帳タブ遷移 |
| **7. StreakBar** | streak=7 で🌟表示 / streak=30 で👑表示 |
| **8. ReplyPanel** | 展開状態確認 / タップで折りたたみ |

### モック戦略

```dart
// Riverpod プロバイダーをオーバーライドして Supabase 不要
ProviderScope(
  overrides: [
    // fake StreakData を注入
    overrideStreakWith(fakeStreakData7()),
    // fake ChatState を注入（FakeChatNotifier を使用）
    overrideChatWith(fakeChatStateWithMessages()),
  ],
  child: const ChatScreen(),
)
```

### FakeChatNotifier の動作

```dart
// generateReply() を呼ぶと即座にフェイク返信を生成
// → Supabase/Gemini API への接続なしでテスト可能
await tester.tap(find.text('✦ 変換'));
await tester.pump();
// → メッセージが追加されたことを確認
```

---

## CI パイプライン推奨構成（GitHub Actions）

```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  unit-widget:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.x'
      - run: flutter pub get
      - run: flutter test test/unit/ test/widget/

  golden-vrt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test test/golden/
      # 差分があれば artifacts に保存して PR コメントで確認
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: golden-failures
          path: test/goldens/failures/

  e2e:
    runs-on: macos-latest  # iOS シミュレータが必要
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test integration_test/e2e_test.dart -d iPhone
```

---

## テストヘルパーの使い方

```dart
import 'package:rizzlang_test/helpers/test_helpers.dart';

// フェイクデータ
final msg  = fakeUserMessage();
final msg  = fakeCharacterMessage();
final reply = fakeGeneratedReply(tensionPhase: 'friction');
final streak = fakeStreakData7();

// チャット状態
final state = fakeChatStateEmpty();
final state = fakeChatStateWithMessages();
final state = fakeChatStateLimitExceeded();
final state = fakeChatStateTension();

// ウィジェットラッパー（プロバイダーオーバーライド付き）
buildTestApp(
  const ChatScreen(),
  overrides: [
    overrideStreakWith(fakeStreakData7()),
    overrideChatWith(fakeChatStateWithMessages()),
  ],
)
```

---

## ゴールデンテストのトラブルシューティング

### フォント未ロードで文字がズレる
```bash
# flutter_test はデフォルトでシステムフォントを使用しない
# → アセットフォントが必要な場合は test/ に fonts/ をシムリンクするか
#   flutter_test_config.dart を作成してフォントをロードする
```

### アニメーション中でゴールデンがブレる
```dart
// pumpAndSettle() ではなく明示的な時間で pump
await tester.pump(const Duration(milliseconds: 300));
// 無限アニメーション (shimmer 等) は pumpAndSettle() がタイムアウトするため注意
```

### 異なる OS でゴールデンが一致しない
```
macOS と Linux でフォントレンダリングが微妙に異なる。
CI は1つの OS（推奨: ubuntu-latest）に固定してゴールデンを生成すること。
```

---

*最終更新: 2026-02-26*
