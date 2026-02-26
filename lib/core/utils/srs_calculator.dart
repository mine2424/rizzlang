/// SM-2 アルゴリズムに基づく SRS（間隔反復学習）スケジューラー。
///
/// [reviewCount]: これまでの復習回数（0始まり）
/// [easeFactor]:  現在の記憶定着係数（デフォルト 2.5）
/// [quality]:     評価スコア（0-5）。3未満でリセット
/// [now]:         基準日時
///
/// 戻り値: 次回復習日
DateTime calcNextReview(
  int reviewCount,
  double easeFactor,
  int quality,
  DateTime now,
) {
  if (quality < 3) {
    // 評価不十分 → 翌日にリセット
    return now.add(const Duration(days: 1));
  }

  int intervalDays;
  switch (reviewCount) {
    case 0:
      intervalDays = 1;
      break;
    case 1:
      intervalDays = 3;
      break;
    case 2:
      intervalDays = 7;
      break;
    default:
      // reviewCount >= 3: 前回インターバル × easeFactor（簡易近似）
      // SM-2 では実際の前回インターバルが必要だが、ここでは 7 * ef^(n-2) で近似
      final n = reviewCount - 2;
      intervalDays = (7 * (easeFactor * n)).round().clamp(7, 365);
  }

  return now.add(Duration(days: intervalDays));
}

/// SM-2 の記憶定着係数更新式
/// EF' = EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
/// EF が 1.3 を下回らないようにクランプ
double updateEaseFactor(double easeFactor, int quality) {
  final delta = 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);
  final newEf = easeFactor + delta;
  return newEf < 1.3 ? 1.3 : newEf;
}
