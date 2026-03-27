import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';

class HeartRateZone {
  final String name;
  final double min;
  final double max;

  HeartRateZone({required this.name, required this.min, required this.max});

  bool contains(double hr, {bool isLast = false}) {
    return isLast ? hr >= min && hr <= max : hr >= min && hr < max;
  }
}

class HeartRateZoneResult {
  final double currentHeartRate;
  final String currentZone;
  final Map<String, double> zonePercentages;

  HeartRateZoneResult({
    required this.currentHeartRate,
    required this.currentZone,
    required this.zonePercentages,
  });
}

class HeartRateZoneCalculator {
  static double calculateMaxHeartRateGeneral(int age) {
    return (220 - age).toDouble();
  }

  /// Tanaka's formula for max HR
  static double calculateMaxHeartRateAdults(int age) {
    return 208 - (0.7 * age);
  }

  static List<HeartRateZone> buildZones(double maxHr) {
    return [
      HeartRateZone(name: 'Rest', min: 0.0, max: 0.5 * maxHr),
      HeartRateZone(name: 'Recovery', min: 0.5 * maxHr, max: 0.6 * maxHr),
      HeartRateZone(name: 'Sustainable', min: 0.6 * maxHr, max: 0.7 * maxHr),
      HeartRateZone(name: 'Caution', min: 0.7 * maxHr, max: 0.85 * maxHr),
      HeartRateZone(name: 'Risk', min: 0.85 * maxHr, max: double.infinity),
    ];
  }

  static String getCurrentZone(double currentHr, List<HeartRateZone> zones) {
    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];
      final isLast = i == zones.length - 1;

      if (zone.contains(currentHr, isLast: isLast)) {
        return zone.name;
      }
    }
    return 'Unknown';
  }

  static Map<String, double> calculateZoneDistribution(
    List<HeartRateEntity> data,
    List<HeartRateZone> zones,
  ) {
    if (data.isEmpty) return {};

    final counts = <String, int>{};

    for (final zone in zones) {
      counts[zone.name] = 0;
    }

    for (final entry in data) {
      final hr = entry.value.clamp(30, 220).toDouble();

      for (final zone in zones) {
        if (zone.contains(hr)) {
          counts[zone.name] = counts[zone.name]! + 1;
          break;
        }
      }
    }

    final total = data.length;

    return counts.map(
      (key, value) => MapEntry(key, total == 0 ? 0 : value / total),
    );
  }

  static HeartRateZoneResult calculateZones({
    required List<HeartRateEntity> data,
    required HeartRateEntity current,
    required UserProfileEntity userProfile,
    HeartRateVariabilityResult? hrv,
    double? maxHeartRate,
  }) {
    if (data.isEmpty) {
      return HeartRateZoneResult(
        currentHeartRate: current.value.toDouble(),
        currentZone: 'Unknown',
        zonePercentages: {},
      );
    }

    double maxHr = maxHeartRate ?? calculateMaxHeartRateAdults(userProfile.age);

    if (hrv != null) {
      if (hrv.rmssd < 20) {
        maxHr *= 0.9;
      } else if (hrv.rmssd > 50) {
        maxHr *= 1.05;
      }
    }

    final zones = buildZones(maxHr);

    final currentZone = getCurrentZone(current.value.toDouble(), zones);

    final distribution = calculateZoneDistribution(data, zones);

    return HeartRateZoneResult(
      currentHeartRate: current.value.toDouble(),
      currentZone: currentZone,
      zonePercentages: distribution,
    );
  }
}
