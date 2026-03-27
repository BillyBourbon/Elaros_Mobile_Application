import 'dart:math' as math;

import 'package:elaros_mobile_app/data/local/model/intensities_states_model.dart';
import 'package:elaros_mobile_app/data/local/model/sleep_states_model.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/intensities_entity.dart';
import 'package:elaros_mobile_app/domain/models/sleep_entity.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';

class EnergyScoreCalculator {
  static double calculateEnergyScore({
    required double weight,
    required List<HeartRateEntity> heartRates,
    required List<SleepEntity> sleepLogs,
    required List<GroupedEntity> steps,
    required List<GroupedEntity> calories,
    required List<IntensityEntity> intensities,
    required List<IntensityStatesModel> intensityStates,
    required List<SleepStatesModel> sleepStates,
    required double hrvBaseline,
  }) {
    final mappedSleepLogs = _mapIntensityToSleep(
      intensities,
      intensityStates,
      sleepStates,
    );
    final hrv = HeartRateVariabilityCalculator.calculateRMSSD(heartRates);

    final recoveryFactor = _clamp(hrv / hrvBaseline, 0.7, 1.3);

    final maxEnergy = (weight * 24) * recoveryFactor;

    final sleepScore = _calculateSleepScore(mappedSleepLogs);
    final energyIn = sleepScore * maxEnergy;

    final energyOut = _calculateEnergyOut(
      steps: steps,
      calories: calories,
      intensities: intensities,
    );

    final recoveryBoost = maxEnergy * (recoveryFactor - 1);

    final currentEnergy = energyIn - energyOut + recoveryBoost;

    final score = (currentEnergy / maxEnergy) * 100;

    return _clamp(score, 0, 100);
  }

  static double _calculateSleepScore(List<SleepEntity> logs) {
    if (logs.isEmpty) return 0;

    double total = 0;
    double weighted = 0;

    for (final log in logs) {
      final weight = _sleepWeight(log.value.toInt());
      weighted += weight;
      total += 1;
    }

    final quality = total == 0 ? 0 : weighted / total;

    const recommendedSleepHours = 8;
    final durationFactor = _clamp(total / recommendedSleepHours, 0, 1);

    return quality * durationFactor;
  }

  static List<SleepEntity> _mapIntensityToSleep(
    List<IntensityEntity> intensities,
    List<IntensityStatesModel> intensityStates,
    List<SleepStatesModel> sleepStates,
  ) {
    final intensityMap = Map<int, int>.fromEntries(
      intensityStates.map(
        (state) => MapEntry(state.id, int.parse(state.value)),
      ),
    );

    final sleepMap = Map<int, int>.fromEntries(
      sleepStates.map((state) => MapEntry(state.id, int.parse(state.value))),
    );

    return intensities.map((intensity) {
      final intensityValue = intensityMap[intensity.value.toInt()] ?? 0;
      final sleepValue = sleepMap[intensityValue] ?? 0;
      return SleepEntity(date: intensity.date, value: sleepValue.toDouble());
    }).toList();
  }

  static double _sleepWeight(int state) {
    switch (state) {
      case 0:
        return 0.0;
      case 1:
        return 0.7;
      case 2:
        return 1.0;
      default:
        return 0.5;
    }
  }

  static double _calculateEnergyOut({
    required List<GroupedEntity> steps,
    required List<GroupedEntity> calories,
    required List<IntensityEntity> intensities,
  }) {
    final totalCalories = calories.fold(0.0, (sum, c) => sum + c.total);

    final totalSteps = steps.fold(0.0, (sum, s) => sum + s.total);

    final avgIntensity = intensities.isEmpty
        ? 0.0
        : intensities.map((e) => e.value).reduce((a, b) => a + b) /
              intensities.length;

    final intensityFactor = _mapIntensity(avgIntensity);

    return totalCalories + (totalSteps * 0.04) + (intensityFactor * 200);
  }

  static double _mapIntensity(double value) {
    if (value <= 1) return 0.5;
    if (value <= 2) return 1.0;
    return 1.5;
  }

  static double _clamp(double v, double min, double max) {
    return math.max(min, math.min(max, v.toDouble()));
  }
}
