import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
import 'package:elaros_mobile_app/domain/models/step_count_model.dart';

class StepCountUseCase {
  final StepCountRepository stepCountRepository;

  StepCountUseCase({required this.stepCountRepository});

  Future<List<StepCountEntity>> getStepCountByDayLastNDays(int days) async {
    final data = await stepCountRepository.getStepCountByDayLastNDays(days);

    return data
        .map((e) => StepCountEntity(date: e.date, value: e.totalSteps))
        .toList();
  }
}
