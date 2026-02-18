import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';

class HeartRateUseCase {
  final HeartRateRepository heartRateRepository;

  HeartRateUseCase({required this.heartRateRepository});

  Future<List<HeartRateEntity>> getHeartRateLastNHours(int hours) async {
    final data = await heartRateRepository.getHeartRateLastNHours(hours);

    return data
        .map((e) => HeartRateEntity(date: e.date, value: e.value))
        .toList();
  }

  Future<List<HeartRateEntity>> getHeartRateLastNDays(int days) async {
    final data = await heartRateRepository.getHeartRateLastNDays(days);

    return data
        .map((e) => HeartRateEntity(date: e.date, value: e.value))
        .toList();
  }

  Future<List<HeartRateEntity>> getHeartRateBetweenDates(
    DateTime start,
    DateTime end,
  ) async {
    final data = await heartRateRepository.getHeartRateBetweenDates(start, end);

    return data
        .map((e) => HeartRateEntity(date: e.date, value: e.value))
        .toList();
  }
}
