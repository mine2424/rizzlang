/// 難易度エンジン — ユーザーの編集率・リトライ数からレベルを自動調整する。
///
/// ルール:
/// - noEditRate > 0.8 && avgRetries < 0.5  → min(4, current + 1) （昇格）
/// - noEditRate < 0.4 || avgRetries > 2.0  → max(1, current - 1) （降格）
/// - それ以外                               → current             （維持）
int calcNextLevel(int current, double noEditRate, double avgRetries) {
  if (noEditRate > 0.8 && avgRetries < 0.5) {
    return (current + 1).clamp(1, 4);
  }
  if (noEditRate < 0.4 || avgRetries > 2.0) {
    return (current - 1).clamp(1, 4);
  }
  return current;
}
