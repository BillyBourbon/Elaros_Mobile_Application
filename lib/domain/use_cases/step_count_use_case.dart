import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
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
}
