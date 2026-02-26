import 'package:flutter_test/flutter_test.dart';
import 'package:rizzlang/core/utils/difficulty_engine.dart';

void main() {
  group('calcNextLevel — 難易度エンジン境界値テスト', () {
    // ── 昇格ケース ─────────────────────────────────────────────
    test('Lv1 / noEditRate=0.9, avgRetries=0.3 → Lv2（昇格）', () {
      expect(calcNextLevel(1, 0.9, 0.3), equals(2));
    });

    test('Lv4（上限）/ noEditRate=0.9, avgRetries=0.3 → Lv4（上限・昇格なし）', () {
      expect(calcNextLevel(4, 0.9, 0.3), equals(4));
    });

    // ── 降格ケース ─────────────────────────────────────────────
    test('Lv2 / noEditRate=0.3, avgRetries=1.0 → Lv1（noEditRate低下で降格）', () {
      expect(calcNextLevel(2, 0.3, 1.0), equals(1));
    });

    test('Lv1（下限）/ noEditRate=0.3, avgRetries=1.0 → Lv1（下限・降格なし）', () {
      expect(calcNextLevel(1, 0.3, 1.0), equals(1));
    });

    test('Lv2 / noEditRate=0.2, avgRetries=3.0 → Lv1（両条件とも降格）', () {
      expect(calcNextLevel(2, 0.2, 3.0), equals(1));
    });

    // ── 維持ケース ─────────────────────────────────────────────
    test('Lv3 / noEditRate=0.6, avgRetries=1.0 → Lv3（維持）', () {
      expect(calcNextLevel(3, 0.6, 1.0), equals(3));
    });

    // ── 境界値ケース ───────────────────────────────────────────
    test('Lv2 / noEditRate=0.8, avgRetries=0.5 → Lv2（境界値・維持）', () {
      // noEditRate > 0.8 は成立しない（0.8 は含まない）
      // avgRetries < 0.5 は成立しない（0.5 は含まない）
      expect(calcNextLevel(2, 0.8, 0.5), equals(2));
    });

    test('Lv2 / noEditRate=0.81, avgRetries=0.49 → Lv3（境界値・昇格）', () {
      // noEditRate > 0.8 かつ avgRetries < 0.5 → 昇格
      expect(calcNextLevel(2, 0.81, 0.49), equals(3));
    });
  });
}
