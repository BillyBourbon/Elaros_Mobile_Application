import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/intensities_entity.dart';
import 'package:elaros_mobile_app/domain/models/sleep_entity.dart';
import 'package:elaros_mobile_app/utils/helpers/energy_score_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnergyScoreCalculator', () {
    final List<GroupedEntity> sampleHeartRates = [
      GroupedEntity(
        time: DateTime(2026, 1, 1),
        entries: 1,
        total: 70,
        first: 70,
        last: 70,
        maximum: 70,
        minimum: 70,
        average: 70,
        median: 70,
      ),
      GroupedEntity(
        time: DateTime(2026, 1, 2),
        entries: 1,
        total: 75,
        first: 75,
        last: 75,
        maximum: 75,
        minimum: 75,
        average: 75,
        median: 75,
      ),
    ];

    final List<SleepEntity> sampleSleepLogs = [
      SleepEntity(date: DateTime(2026, 1, 1), value: 2.0), // Deep sleep
      SleepEntity(date: DateTime(2026, 1, 2), value: 2.0), // Deep sleep
    ];

    final List<GroupedEntity> sampleSteps = [
      GroupedEntity(
        time: DateTime(2026, 1, 1),
        entries: 1,
        total: 5000,
        first: 5000,
        last: 5000,
        maximum: 5000,
        minimum: 5000,
        average: 5000,
        median: 5000,
      ),
      GroupedEntity(
        time: DateTime(2026, 1, 2),
        entries: 1,
        total: 6000,
        first: 6000,
        last: 6000,
        maximum: 6000,
        minimum: 6000,
        average: 6000,
        median: 6000,
      ),
    ];

    final List<GroupedEntity> sampleCalories = [
      GroupedEntity(
        time: DateTime(2026, 1, 1),
        entries: 1,
        total: 2000,
        first: 2000,
        last: 2000,
        maximum: 2000,
        minimum: 2000,
        average: 2000,
        median: 2000,
      ),
      GroupedEntity(
        time: DateTime(2026, 1, 2),
        entries: 1,
        total: 2200,
        first: 2200,
        last: 2200,
        maximum: 2200,
        minimum: 2200,
        average: 2200,
        median: 2200,
      ),
    ];

    final List<IntensityEntity> sampleIntensities = [
      IntensityEntity(date: DateTime(2026, 1, 1), value: 1.5),
      IntensityEntity(date: DateTime(2026, 1, 2), value: 1.8),
    ];

    const double sampleHrvBaseline = 50.0;
    const double sampleWeight = 70.0;

    test(
      'calculateEnergyScore with typical input values returns score between 0 and 100',
      () {
        final score = EnergyScoreCalculator.calculateEnergyScore(
          weight: sampleWeight,
          heartRates: sampleHeartRates,
          sleepLogs: sampleSleepLogs,
          steps: sampleSteps,
          calories: sampleCalories,
          intensities: sampleIntensities,
          hrvBaseline: sampleHrvBaseline,
        );

        expect(score, greaterThanOrEqualTo(0));
        expect(score, lessThanOrEqualTo(100));
      },
    );

    test('calculateEnergyScore with empty lists returns 0', () {
      final score = EnergyScoreCalculator.calculateEnergyScore(
        weight: sampleWeight,
        heartRates: [],
        sleepLogs: [],
        steps: [],
        calories: [],
        intensities: [],
        hrvBaseline: sampleHrvBaseline,
      );

      expect(score, equals(0));
    });

    test('calculateEnergyScore with zero weight returns 0', () {
      final score = EnergyScoreCalculator.calculateEnergyScore(
        weight: 0,
        heartRates: sampleHeartRates,
        sleepLogs: sampleSleepLogs,
        steps: sampleSteps,
        calories: sampleCalories,
        intensities: sampleIntensities,
        hrvBaseline: sampleHrvBaseline,
      );

      expect(score, equals(0));
    });

    test('calculateEnergyScore with very high weight clamps to 100', () {
      // Using extremely high weight to potentially exceed max energy
      final score = EnergyScoreCalculator.calculateEnergyScore(
        weight: 1000, // Very high weight
        heartRates: sampleHeartRates,
        sleepLogs: sampleSleepLogs,
        steps: sampleSteps,
        calories: sampleCalories,
        intensities: sampleIntensities,
        hrvBaseline: sampleHrvBaseline,
      );

      expect(score, lessThanOrEqualTo(100));
    });

    test(
      'calculateEnergyScore with HRV baseline > 0 avoids division by zero',
      () {
        final score = EnergyScoreCalculator.calculateEnergyScore(
          weight: sampleWeight,
          heartRates: sampleHeartRates,
          sleepLogs: sampleSleepLogs,
          steps: sampleSteps,
          calories: sampleCalories,
          intensities: sampleIntensities,
          hrvBaseline: 1.0, // Small but non-zero baseline
        );

        expect(score, greaterThanOrEqualTo(0));
        expect(score, lessThanOrEqualTo(100));
      },
    );
  });
}
