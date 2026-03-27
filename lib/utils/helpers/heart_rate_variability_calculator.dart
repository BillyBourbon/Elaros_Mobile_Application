import 'dart:math' as math;

import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';

class HeartRateVariabilityResult {
  final double rmssd;
  final double sdnn;
  final int nn50;
  final double pnn50;

  HeartRateVariabilityResult({
    required this.rmssd,
    required this.sdnn,
    required this.nn50,
    required this.pnn50,
  });

  @override
  String toString() {
    return 'HRV(rmssd: $rmssd, sdnn: $sdnn, nn50: $nn50, pnn50: $pnn50)';
  }
}

class HeartRateVariabilityCalculator {
  /// Converts BeatsPerMinute to RR interval in milliseconds
  /// RR (ms) = 60000 / BPM
  static double _bpmToRr(int bpm) {
    if (bpm <= 0) {
      throw ArgumentError('Heart rate must be greater than 0');
    }
    return 60000.0 / bpm;
  }

  static List<double> _getRrIntervals(List<HeartRateEntity> data) {
    return data.map((e) => _bpmToRr(e.value.toInt())).toList();
  }

  // Heart Rate Variability Formulas

  /// Root Mean Square of Successive Differences (RMSSD)
  ///
  static double calculateRMSSD(List<HeartRateEntity> data) {
    final rr = _getRrIntervals(data);

    if (rr.length < 2) return 0;

    double sum = 0;

    for (int i = 1; i < rr.length; i++) {
      final diff = rr[i] - rr[i - 1];
      sum += diff * diff;
    }

    return math.sqrt(sum / (rr.length - 1));
  }

  /// Standard Deviation of NN intervals (SDNN)
  ///
  static double calculateSDNN(List<HeartRateEntity> data) {
    final rr = _getRrIntervals(data);

    if (rr.isEmpty) return 0;

    final mean = rr.reduce((a, b) => a + b) / rr.length;

    final variance =
        rr.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) /
        rr.length;

    return math.sqrt(variance);
  }

  /// NN50: Number of successive RR interval differences > 50ms
  ///
  static int calculateNN50(List<HeartRateEntity> data) {
    final rr = _getRrIntervals(data);

    int count = 0;

    for (int i = 1; i < rr.length; i++) {
      if ((rr[i] - rr[i - 1]).abs() > 50) {
        count++;
      }
    }

    return count;
  }

  /// pNN50: Percentage of NN50 over total intervals
  ///
  static double calculatePNN50(List<HeartRateEntity> data) {
    final rr = _getRrIntervals(data);

    if (rr.length < 2) return 0;

    final nn50 = calculateNN50(data);

    return (nn50 / (rr.length - 1)) * 100;
  }

  static HeartRateVariabilityResult calculateAll(List<HeartRateEntity> data) {
    return HeartRateVariabilityResult(
      rmssd: calculateRMSSD(data),
      sdnn: calculateSDNN(data),
      nn50: calculateNN50(data),
      pnn50: calculatePNN50(data),
    );
  }
}
