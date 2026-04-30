import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeartRateVariabilityCalculator', () {
    final List<HeartRateEntity> sampleData = [
      HeartRateEntity(
        date: DateTime(2026, 1, 1),
        value: 60,
      ), // 60 BPM -> 1000 ms RR
      HeartRateEntity(
        date: DateTime(2026, 1, 2),
        value: 60,
      ), // 60 BPM -> 1000 ms RR
    ];

    final List<HeartRateEntity> sampleDataDiff = [
      HeartRateEntity(
        date: DateTime(2026, 1, 1),
        value: 60,
      ), // 60 BPM -> 1000 ms RR
      HeartRateEntity(
        date: DateTime(2026, 1, 2),
        value: 50,
      ), // 50 BPM -> 1200 ms RR
    ];

    test('calculateRMSSD with empty list returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateRMSSD([]);
      expect(result, equals(0));
    });

    test('calculateRMSSD with single element returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateRMSSD([
        HeartRateEntity(date: DateTime(2026, 1, 1), value: 60),
      ]);
      expect(result, equals(0));
    });

    test('calculateRMSSD with two elements with same value returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateRMSSD(sampleData);
      expect(result, equals(0));
    });

    test('calculateRMSSD with two elements with known difference', () {
      final result = HeartRateVariabilityCalculator.calculateRMSSD(
        sampleDataDiff,
      );
      expect(result, closeTo(200.0, 0.001));
    });

    test('calculateSDNN with empty list returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateSDNN([]);
      expect(result, equals(0));
    });

    test('calculateSDNN with single element returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateSDNN([
        HeartRateEntity(date: DateTime(2026, 1, 1), value: 60),
      ]);
      expect(result, equals(0));
    });

    test('calculateSDNN with two elements with same value returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateSDNN(sampleData);
      expect(result, equals(0));
    });

    test('calculateSDNN with two elements with known values', () {
      final result = HeartRateVariabilityCalculator.calculateSDNN(
        sampleDataDiff,
      );
      // RR intervals: [1000, 1200]
      // mean = 1100
      // variance = ((1000-1100)^2 + (1200-1100)^2)/2 = (10000+10000)/2 = 10000
      // SDNN = sqrt(10000) = 100
      expect(result, closeTo(100.0, 0.001));
    });

    test('calculateNN50 with empty list returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateNN50([]);
      expect(result, equals(0));
    });

    test('calculateNN50 with single element returns 0', () {
      final result = HeartRateVariabilityCalculator.calculateNN50([
        HeartRateEntity(date: DateTime(2026, 1, 1), value: 60),
      ]);
      expect(result, equals(0));
    });

    test('calculateNN50 with two elements where difference >50 returns 1', () {
      final data = [
        HeartRateEntity(
          date: DateTime(2026, 1, 1),
          value: 60,
        ), // 60 BPM -> 1000 ms RR
        HeartRateEntity(
          date: DateTime(2026, 1, 2),
          value: 40,
        ), // 40 BPM -> 1500 ms RR
      ];
      // RR intervals: [1000, 1500], diff: 500 > 50
      final result = HeartRateVariabilityCalculator.calculateNN50(data);
      expect(result, equals(1));
    });

    test('calculateNN50 with two elements where difference <=50 returns 0', () {
      final data = [
        HeartRateEntity(
          date: DateTime(2026, 1, 1),
          value: 60,
        ), // 60 BPM -> 1000 ms RR
        HeartRateEntity(
          date: DateTime(2026, 1, 2),
          value: 58,
        ), // 58 BPM -> ~1034.48 ms RR
      ];
      // RR intervals: [1000, ~1034.48], diff: ~34.48 <= 50
      final result = HeartRateVariabilityCalculator.calculateNN50(data);
      expect(result, equals(0));
    });

    test('calculatePNN50 with empty list returns 0', () {
      final result = HeartRateVariabilityCalculator.calculatePNN50([]);
      expect(result, equals(0));
    });

    test('calculatePNN50 with single element returns 0', () {
      final result = HeartRateVariabilityCalculator.calculatePNN50([
        HeartRateEntity(date: DateTime(2026, 1, 1), value: 60),
      ]);
      expect(result, equals(0));
    });

    test(
      'calculatePNN50 with two elements where one successive difference >50 returns 100',
      () {
        final data = [
          HeartRateEntity(
            date: DateTime(2026, 1, 1),
            value: 60,
          ), // 60 BPM -> 1000 ms RR
          HeartRateEntity(
            date: DateTime(2026, 1, 2),
            value: 40,
          ), // 40 BPM -> 1500 ms RR
        ];
        // RR intervals: [1000, 1500], diff: 500 > 50
        // nn50 = 1, total intervals = 1, pnn50 = (1/1)*100 = 100
        final result = HeartRateVariabilityCalculator.calculatePNN50(data);
        expect(result, closeTo(100.0, 0.001));
      },
    );

    test(
      'calculatePNN50 with two elements where difference <=50 returns 0',
      () {
        final data = [
          HeartRateEntity(
            date: DateTime(2026, 1, 1),
            value: 60,
          ), // 60 BPM -> 1000 ms RR
          HeartRateEntity(
            date: DateTime(2026, 1, 2),
            value: 58,
          ), // 58 BPM -> ~1034.48 ms RR
        ];
        // RR intervals: [1000, ~1034.48], diff: ~34.48 <= 50
        // nn50 = 0, total intervals = 1, pnn50 = (0/1)*100 = 0
        final result = HeartRateVariabilityCalculator.calculatePNN50(data);
        expect(result, equals(0));
      },
    );

    test('calculateAll computes all values correctly', () {
      // Use data that gives us known values for all metrics
      final data = [
        HeartRateEntity(
          date: DateTime(2026, 1, 1),
          value: 60,
        ), // 60 BPM -> 1000 ms RR
        HeartRateEntity(
          date: DateTime(2026, 1, 2),
          value: 50,
        ), // 50 BPM -> 1200 ms RR
        HeartRateEntity(
          date: DateTime(2026, 1, 3),
          value: 60,
        ), // 60 BPM -> 1000 ms RR
      ];

      final result = HeartRateVariabilityCalculator.calculateAll(data);

      // RR intervals: [1000, 1200, 1000]
      // Differences: [200, -200]
      // Squared differences: [40000, 40000]
      // RMSSD = sqrt((40000+40000)/2) = sqrt(40000) = 200

      // SDNN: mean = (1000+1200+1000)/3 = 1066.67
      // Variance = ((1000-1066.67)^2 + (1200-1066.67)^2 + (1000-1066.67)^2)/3
      //         = (4444.89 + 17777.89 + 4444.89)/3 = 26667.67/3 = 8889.22
      // SDNN = sqrt(8889.22) ≈ 94.28

      // NN50: both differences (200, -200) have abs > 50, so count = 2

      // PNN50: (2/2)*100 = 100

      expect(result.rmssd, closeTo(200.0, 0.001));
      expect(result.sdnn, closeTo(94.28, 0.01));
      expect(result.nn50, equals(2));
      expect(result.pnn50, closeTo(100.0, 0.001));
    });
  });
}
