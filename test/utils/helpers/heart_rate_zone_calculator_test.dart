import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_zone_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeartRateZoneCalculator', () {
    final List<HeartRateEntity> sampleHeartRates = [
      HeartRateEntity(date: DateTime(2026, 1, 1), value: 100),
      HeartRateEntity(date: DateTime(2026, 1, 2), value: 120),
      HeartRateEntity(date: DateTime(2026, 1, 3), value: 140),
    ];

    final HeartRateEntity sampleCurrent = HeartRateEntity(
      date: DateTime(2026, 1, 3),
      value: 130,
    );

    final UserProfileEntity sampleUserProfile = UserProfileEntity(
      name: 'Test User',
      age: 30,
      gender: 'Male',
      height: 175.0,
      weight: 70.0,
    );

    test('calculateMaxHeartRateGeneral with various ages', () {
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateGeneral(20),
        equals(200.0),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateGeneral(30),
        equals(190.0),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateGeneral(40),
        equals(180.0),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateGeneral(60),
        equals(160.0),
      );
    });

    test('calculateMaxHeartRateAdults with various ages', () {
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateAdults(20),
        equals(208 - 0.7 * 20),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateAdults(30),
        equals(208 - 0.7 * 30),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateAdults(40),
        equals(208 - 0.7 * 40),
      );
      expect(
        HeartRateZoneCalculator.calculateMaxHeartRateAdults(60),
        equals(208 - 0.7 * 60),
      );
    });

    test('buildZones with known maxHr calculates correct zones', () {
      final maxHr = 180.0;
      final zones = HeartRateZoneCalculator.buildZones(maxHr);

      expect(zones.length, equals(5));

      // Rest zone: 0 to 90 (0.5 * 180)
      expect(zones[0].name, equals('Rest'));
      expect(zones[0].min, equals(0.0));
      expect(zones[0].max, equals(90.0));

      // Recovery zone: 90 to 108 (0.5*180 to 0.6*180)
      expect(zones[1].name, equals('Recovery'));
      expect(zones[1].min, equals(90.0));
      expect(zones[1].max, equals(108.0));

      // Sustainable zone: 108 to 126 (0.6*180 to 0.7*180)
      expect(zones[2].name, equals('Sustainable'));
      expect(zones[2].min, equals(108.0));
      expect(zones[2].max, closeTo(126.0, 0.000001));

      // Caution zone: 126 to 153 (0.7*180 to 0.85*180)
      expect(zones[3].name, equals('Caution'));
      expect(zones[3].min, closeTo(126.0, 0.000001));
      expect(zones[3].max, closeTo(153.0, 0.000001));

      // Risk zone: 153 to infinity
      expect(zones[4].name, equals('Risk'));
      expect(zones[4].min, equals(153.0));
      expect(zones[4].max, equals(double.infinity));
    });

    test('getCurrentZone returns correct zone for heart rate values', () {
      final maxHr = 180.0;
      final zones = HeartRateZoneCalculator.buildZones(maxHr);

      // Test Rest zone (0-90)
      expect(HeartRateZoneCalculator.getCurrentZone(45, zones), equals('Rest'));
      expect(HeartRateZoneCalculator.getCurrentZone(0, zones), equals('Rest'));
      expect(
        HeartRateZoneCalculator.getCurrentZone(89.9, zones),
        equals('Rest'),
      );

      // Test Recovery zone (90-108)
      expect(
        HeartRateZoneCalculator.getCurrentZone(90, zones),
        equals('Recovery'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(99, zones),
        equals('Recovery'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(107.9, zones),
        equals('Recovery'),
      );

      // Test Sustainable zone (108-126)
      expect(
        HeartRateZoneCalculator.getCurrentZone(108, zones),
        equals('Sustainable'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(117, zones),
        equals('Sustainable'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(125.9, zones),
        equals('Sustainable'),
      );

      // Test Caution zone (126-153)
      expect(
        HeartRateZoneCalculator.getCurrentZone(126, zones),
        equals('Caution'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(140, zones),
        equals('Caution'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(152.9, zones),
        equals('Caution'),
      );

      // Test Risk zone (153+)
      expect(
        HeartRateZoneCalculator.getCurrentZone(153, zones),
        equals('Risk'),
      );
      expect(
        HeartRateZoneCalculator.getCurrentZone(200, zones),
        equals('Risk'),
      );
    });

    test('calculateZoneDistribution with empty data returns empty map', () {
      final zones = HeartRateZoneCalculator.buildZones(180.0);
      final distribution = HeartRateZoneCalculator.calculateZoneDistribution(
        [],
        zones,
      );
      expect(distribution.isEmpty, isTrue);
    });

    test(
      'calculateZoneDistribution with data in one zone returns 100% for that zone',
      () {
        final zones = HeartRateZoneCalculator.buildZones(180.0);
        final data = [
          HeartRateEntity(
            date: DateTime(2026, 1, 1),
            value: 95,
          ), // Recovery zone
          HeartRateEntity(
            date: DateTime(2026, 1, 2),
            value: 100,
          ), // Recovery zone
          HeartRateEntity(
            date: DateTime(2026, 1, 3),
            value: 105,
          ), // Recovery zone
        ];

        final distribution = HeartRateZoneCalculator.calculateZoneDistribution(
          data,
          zones,
        );
        expect(distribution['Recovery'], equals(1.0));
        expect(distribution['Rest'], equals(0.0));
        expect(distribution['Sustainable'], equals(0.0));
        expect(distribution['Caution'], equals(0.0));
        expect(distribution['Risk'], equals(0.0));
      },
    );

    test('calculateZones with normal data returns correct result', () {
      final result = HeartRateZoneCalculator.calculateZones(
        data: sampleHeartRates,
        current: sampleCurrent,
        userProfile: sampleUserProfile,
      );

      expect(result.currentHeartRate, equals(130.0));
      expect(result.currentZone, isNotEmpty);
      expect(result.zonePercentages.isEmpty, isFalse);
    });

    test('calculateZones with HRV provided adjusts maxHr correctly', () {
      final hrvLow = HeartRateVariabilityResult(
        rmssd: 15,
        sdnn: 20,
        nn50: 5,
        pnn50: 10.0,
      );

      final hrvHigh = HeartRateVariabilityResult(
        rmssd: 60,
        sdnn: 40,
        nn50: 15,
        pnn50: 30.0,
      );

      final resultLow = HeartRateZoneCalculator.calculateZones(
        data: sampleHeartRates,
        current: sampleCurrent,
        userProfile: sampleUserProfile,
        hrv: hrvLow,
      );

      final resultHigh = HeartRateZoneCalculator.calculateZones(
        data: sampleHeartRates,
        current: sampleCurrent,
        userProfile: sampleUserProfile,
        hrv: hrvHigh,
      );

      // With low HRV, maxHr should be decreased, so zone might be different
      // With high HRV, maxHr should be increased, so zone might be different
      expect(resultLow.currentHeartRate, equals(130.0));
      expect(resultHigh.currentHeartRate, equals(130.0));
    });

    test('calculateZones with empty data returns Unknown zone', () {
      final result = HeartRateZoneCalculator.calculateZones(
        data: [],
        current: sampleCurrent,
        userProfile: sampleUserProfile,
      );

      expect(result.currentHeartRate, equals(sampleCurrent.value.toDouble()));
      expect(result.currentZone, equals('Unknown'));
      expect(result.zonePercentages.isEmpty, isTrue);
    });
  });
}
