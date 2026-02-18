import 'package:elaros_mobile_app/data/local/model/step_count_model.dart';
import 'package:elaros_mobile_app/data/local/services/step_count_service.dart';

class StepCountRepository {
  final StepCountService _service;

  static final StepCountRepository _instance = StepCountRepository._internal(
    StepCountService(),
  );
  factory StepCountRepository() => _instance;
  StepCountRepository._internal(this._service);

  factory StepCountRepository.forTest(StepCountService service) {
    return StepCountRepository._internal(service);
  }

  /// Get step count data from the last N days
  Future<List<StepCountModel>> getStepCountByDayLastNDays(int days) async {
    final rawData = await _service.getStepCountByDayLastNDays(days);
    return rawData.map((e) => StepCountModel.fromMap(e)).toList();
  }
}
