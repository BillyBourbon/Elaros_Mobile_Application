import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/step_count_model.dart';

class StepCountUseCase {
  final StepCountRepository stepCountRepository;

  StepCountUseCase({required this.stepCountRepository});

  /// Get latest step count entry
  Future<StepCountEntity?> getLatestStepCount() async {
    final latestEntry = await stepCountRepository.getLatestEntry();

    return latestEntry == null
        ? null
        : StepCountEntity(date: latestEntry.time, value: latestEntry.value);
  }

  Future<List<GroupedEntity>> getPast24Hrs() async {
    final results = await stepCountRepository.getDataGroupedByHour(
      start: clock.now().subtract(const Duration(days: 1)),
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<List<GroupedEntity>?> getGroupedDataByDays({required int days}) async {
    final results = await stepCountRepository.getDataGroupedByDay(
      start: clock.now().subtract(Duration(days: days)),
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }
}
