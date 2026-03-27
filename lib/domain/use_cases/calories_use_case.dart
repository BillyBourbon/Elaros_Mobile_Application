import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/repositories/calories_repository.dart';
import 'package:elaros_mobile_app/domain/models/calories_entity.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';

class CaloriesUseCase {
  final CaloriesRepository caloriesRepository;

  CaloriesUseCase({required this.caloriesRepository});

  Future<CaloriesEntity?> getLatestCalories() async {
    final latestEntry = await caloriesRepository.getLatestEntry();

    return latestEntry == null
        ? null
        : CaloriesEntity(date: latestEntry.time, value: latestEntry.value);
  }

  Future<List<GroupedEntity>> getPast24Hrs() async {
    final results = await caloriesRepository.getDataGroupedByHour(
      start: clock.now().subtract(const Duration(days: 1)),
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }
}
