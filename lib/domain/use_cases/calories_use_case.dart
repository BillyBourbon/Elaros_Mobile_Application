import 'package:elaros_mobile_app/data/local/repositories/calories_repository.dart';
import 'package:elaros_mobile_app/domain/models/calories_entity.dart';

class CaloriesUseCase {
  final CaloriesRepository caloriesRepository;

  CaloriesUseCase({required this.caloriesRepository});

  Future<CaloriesEntity?> getLatestCalories() async {
    final latestEntry = await caloriesRepository.getLatestEntry();

    return latestEntry == null
        ? null
        : CaloriesEntity(date: latestEntry.time, value: latestEntry.value);
  }
}
