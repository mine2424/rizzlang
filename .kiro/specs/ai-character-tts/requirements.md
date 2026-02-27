# Requirements — キャラクター音声（Character TTS）

## Introduction

キャラクターのメッセージをネイティブ発音で読み上げるTTS機能。
学習者はリスニング練習ができ、正しい発音を耳で覚えられる。
サーバーコスト不要（デバイスOSのTTSエンジン使用）。

**優先度:** 🔴 高（リスニング練習 + エンゲージメント向上）

---

## Requirements

### Requirement 1: 読み上げボタンの表示と操作

#### Acceptance Criteria

1. When キャラクターのメッセージバブルが表示された場合, RizzLang shall バブル右下に 🔊 アイコンボタンを表示する（ユーザー自身のメッセージには表示しない）
2. When ユーザーが 🔊 ボタンをタップした場合, RizzLang shall アクティブキャラクターの言語設定でメッセージテキストを読み上げる
3. When 読み上げ中の場合, RizzLang shall アイコンを ⏹ に変更し、タップで読み上げを停止できる
4. When 別のメッセージの 🔊 をタップした場合, RizzLang shall 現在の読み上げを停止して新しいメッセージを読み上げる

---

### Requirement 2: 言語設定と速度

#### Acceptance Criteria

1. The RizzLang shall `activeCharacterProvider` の言語コードに応じてTTSエンジンの言語を切り替える（ko→ko-KR / en→en-US / tr→tr-TR / vi→vi-VN / ar→ar-SA）
2. The RizzLang shall 読み上げ速度を 0.85（通常より少し遅め）に設定し、学習者が聞き取りやすくする
3. The RizzLang shall ピッチを 1.1 に設定してキャラクターの女性的な声色を演出する
4. If 対象言語のTTSエンジンがデバイスにインストールされていない場合, RizzLang shall 🔊 ボタンをグレーアウトし「このデバイスでは利用できません」をツールチップで表示する

---

### Requirement 3: 設定

#### Acceptance Criteria

1. The RizzLang shall 設定画面に「音声読み上げ」のON/OFFトグルを追加する
2. When 音声読み上げがOFFの場合, RizzLang shall メッセージバブルの 🔊 ボタンを非表示にする
3. The RizzLang shall 設定値を SharedPreferences に永続化する

---

## Out of Scope

- サーバーサイドTTS（Google Cloud TTS API 等）— コスト不要のデバイスTTSで十分
- 音声速度の細かいユーザー調整 UI（Phase 2）
- 発音評価・スコアリング機能（Phase 3）
