import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';

class HeartRateUseCase {
  final HeartRateRepository _repository;

  HeartRateUseCase(this._repository);

  /// Get latest heart rate entry
  Future<HeartRateEntity?> getLatestHeartRate() async {
    final HeartRateModel? latestEntry = await _repository.getLatestEntry();

    return latestEntry == null
        ? null
        : HeartRateEntity(date: latestEntry.time, value: latestEntry.value);
  }

  Future<List<GroupedEntity>> getGroupedDataByMinute(
    DateTime start,
    DateTime? end,
  ) async {
    final results = await _repository.getDataGroupedByMinute(start, end);

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }
}
