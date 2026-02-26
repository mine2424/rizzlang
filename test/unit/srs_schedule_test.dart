import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/core/utils/srs_calculator.dart';

void main() {
  final now = DateTime(2026, 2, 26, 12, 0, 0);

  group('calcNextReview — SM-2 スケジュール計算テスト', () {
    test('reviewCount=0, quality=3 → nextReview = now+1日', () {
      final next = calcNextReview(0, 2.5, 3, now);
      expect(next, equals(now.add(const Duration(days: 1))));
    });

    test('reviewCount=0, quality=5 → nextReview = now+1日', () {
      final next = calcNextReview(0, 2.5, 5, now);
      expect(next, equals(now.add(const Duration(days: 1))));
    });

    test('reviewCount=1, quality=3 → nextReview = now+3日', () {
      final next = calcNextReview(1, 2.5, 3, now);
      expect(next, equals(now.add(const Duration(days: 3))));
    });

    test('reviewCount=2, quality=4 → nextReview = now+7日', () {
      final next = calcNextReview(2, 2.5, 4, now);
      expect(next, equals(now.add(const Duration(days: 7))));
    });

    test('quality<3 → nextReview = now+1日（リセット）', () {
      final next = calcNextReview(5, 2.5, 2, now);
      expect(next, equals(now.add(const Duration(days: 1))));
    });

    test('quality=0（最低評価）→ nextReview = now+1日（リセット）', () {
      final next = calcNextReview(3, 2.5, 0, now);
      expect(next, equals(now.add(const Duration(days: 1))));
    });
  });

  group('updateEaseFactor — EF 更新テスト', () {
    test('quality=5 → EF が増加する（2.5 + delta）', () {
      final newEf = updateEaseFactor(2.5, 5);
      // delta = 0.1 - (5-5)*(0.08+(5-5)*0.02) = 0.1
      expect(newEf, closeTo(2.6, 0.001));
    });

    test('quality=3 → EF がわずかに減少する', () {
      final newEf = updateEaseFactor(2.5, 3);
      // delta = 0.1 - (5-3)*(0.08+(5-3)*0.02) = 0.1 - 2*(0.08+0.04) = 0.1 - 0.24 = -0.14
      expect(newEf, closeTo(2.36, 0.001));
    });

    test('EF が 1.3 を下回らないようにクランプされる', () {
      final newEf = updateEaseFactor(1.3, 0);
      expect(newEf, greaterThanOrEqualTo(1.3));
    });
  });
}
