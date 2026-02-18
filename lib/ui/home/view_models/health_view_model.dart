import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/data/local/services/health_data_service.dart';
import 'package:elaros_mobile_app/data/local/model/hr_zone.dart';

// Re-export so views that import from here still get HRZone / hrZoneDefinitions.
export 'package:elaros_mobile_app/data/local/model/hr_zone.dart';

class HealthViewModel extends ChangeNotifier {
  final HealthDataService _service = HealthDataService();

  bool isLoading = true;
  String? error;

  // Heart rate – all values fetched from the database
  int latestHR = 0;
  int minHR = 0; // resting HR from DB
  int maxHR = 0; // max HR from DB
  int avgHR = 0;
  List<Map<String, dynamic>> hourlyHeartRate = [];

  // Steps
  int todaySteps = 0;
  List<Map<String, dynamic>> dailySteps = [];

  // Calories
  double todayCalories = 0;
  List<Map<String, dynamic>> dailyCalories = [];

  // Sleep
  int sleepTotalMinutes = 0;
  int sleepAsleepMinutes = 0;
  int sleepRestlessMinutes = 0;
  int sleepAwakeMinutes = 0;
  List<Map<String, dynamic>> sleepBreakdown = [];

  // ---------------------------------------------------------------------------
  // HRR-based zone calculation (Heart Rate Reserve method)
  //
  //   HRR = maxHR - restingHR  (both from DB)
  //   Zone boundary = restingHR + (HRR × percentage)
  //
  // Zone 1 (Recovery):      0–30% HRR
  // Zone 2 (Sustainable):  30–50% HRR
  // Zone 3 (Caution):      50–65% HRR
  // Zone 4 (Risk):         65–80% HRR
  // Zone 5 (Overexertion): 80–100% HRR
  // ---------------------------------------------------------------------------

  int get _hrr => maxHR - minHR;

  /// Upper HR boundary for a given HRR percentage, computed from DB values.
  int zoneBoundary(double pct) => (minHR + (_hrr * pct)).round();

  /// Determine which zone a heart rate value falls into using DB-driven
  /// resting/max HR and the HRR formula.
  HRZone zoneForHR(int hr) {
    if (_hrr <= 0) return hrZoneDefinitions[0];
    for (final zone in hrZoneDefinitions) {
      final upper = zoneBoundary(zone.upperPct);
      if (hr <= upper) return zone;
    }
    return hrZoneDefinitions.last;
  }

  HRZone get currentZone => zoneForHR(latestHR);

  int get recoveryScore {
    if (minHR == 0) return 0;
    int score = 100;
    if (minHR > 70) score -= (minHR - 70) * 2;
    if (sleepTotalMinutes < 360) score -= (360 - sleepTotalMinutes) ~/ 10;
    return score.clamp(0, 100);
  }

  Future<void> loadAllData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadHeartRate(),
        _loadSteps(),
        _loadCalories(),
        _loadSleep(),
      ]);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadHeartRate() async {
    final summary = await _service.getHeartRateSummary();
    latestHR = (summary['latestHR'] as num?)?.toInt() ?? 0;
    minHR = (summary['minHR'] as num?)?.toInt() ?? 0;
    maxHR = (summary['maxHR'] as num?)?.toInt() ?? 0;
    avgHR = (summary['avgHR'] as num?)?.toInt() ?? 0;

    final hourly = await _service.getHourlyHeartRate();
    hourlyHeartRate = hourly.map((row) {
      final hr = (row['avgHR'] as num).toInt();
      return {
        'hour': int.parse(row['hour'] as String),
        'avgHR': hr,
        'zone': zoneForHR(hr).number,
      };
    }).toList();
  }

  Future<void> _loadSteps() async {
    final summary = await _service.getStepsSummary();
    todaySteps = (summary['totalSteps'] as num?)?.toInt() ?? 0;

    final daily = await _service.getDailySteps();
    dailySteps = daily.reversed.map((row) {
      final dateStr = row['date'] as String;
      final shortDate = dateStr.substring(5);
      return {
        'date': shortDate,
        'steps': (row['totalSteps'] as num?)?.toInt() ?? 0,
      };
    }).toList();
  }

  Future<void> _loadCalories() async {
    final summary = await _service.getCaloriesSummary();
    todayCalories = (summary['totalCalories'] as num?)?.toDouble() ?? 0;

    final daily = await _service.getDailyCalories();
    dailyCalories = daily.reversed.map((row) {
      final dateStr = row['date'] as String;
      final shortDate = dateStr.substring(5);
      return {
        'date': shortDate,
        'calories': (row['totalCalories'] as num?)?.toDouble() ?? 0,
      };
    }).toList();
  }

  Future<void> _loadSleep() async {
    final summary = await _service.getSleepSummary();
    sleepTotalMinutes = (summary['totalMinutes'] as num?)?.toInt() ?? 0;
    sleepAsleepMinutes = (summary['asleepMinutes'] as num?)?.toInt() ?? 0;
    sleepRestlessMinutes = (summary['restlessMinutes'] as num?)?.toInt() ?? 0;
    sleepAwakeMinutes = (summary['awakeMinutes'] as num?)?.toInt() ?? 0;

    final breakdown = await _service.getSleepBreakdown();
    sleepBreakdown = breakdown.map((row) {
      return {
        'state': row['state'] as String,
        'minutes': (row['minutes'] as num).toInt(),
      };
    }).toList();
  }

  String get sleepDuration {
    final hours = sleepTotalMinutes ~/ 60;
    final minutes = sleepTotalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final buffer = StringBuffer();
      for (var i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }
}
