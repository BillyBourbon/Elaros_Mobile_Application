import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/services/heart_rate_service.dart';

class HeartRateRepository {
  final HeartRateService _service;

  static final HeartRateRepository _instance = HeartRateRepository._internal(
    HeartRateService(),
  );
  factory HeartRateRepository() => _instance;
  HeartRateRepository._internal(this._service);

  factory HeartRateRepository.forTest(HeartRateService service) {
    return HeartRateRepository._internal(service);
  }

  /// Get heart rate data between two dates
  Future<List<HeartRateModel>> getHeartRateBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final rawData = await _service.getHeartRateBetweenDates(start, end);
    return rawData.map((e) => HeartRateModel.fromMap(e)).toList();
  }

  /// Get heart rate data from the last N days
  Future<List<HeartRateModel>> getHeartRateLastNDays(int days) async {
    final rawData = await _service.getHeartRateLastNDays(days);
    return rawData.map((e) => HeartRateModel.fromMap(e)).toList();
  }

  /// Get heart rate data from the last N hours
  Future<List<HeartRateModel>> getHeartRateLastNHours(int hours) async {
    final rawData = await _service.getHeartRateLastNHours(hours);
    return rawData.map((e) => HeartRateModel.fromMap(e)).toList();
  }
}
