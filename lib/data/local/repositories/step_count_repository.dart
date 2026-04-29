import 'package:elaros_mobile_app/data/local/model/step_count_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/base_health_data_repositiory.dart';
import 'package:elaros_mobile_app/data/local/services/step_count_service.dart';

class StepCountRepository
    extends BaseHealthDataRepository<StepCountModel, StepCountService> {
  static final StepCountRepository _instance = StepCountRepository._internal(
    StepCountService(),
  );
  factory StepCountRepository() => _instance;
  StepCountRepository._internal(super.service);

  factory StepCountRepository.forTest(StepCountService service) {
    return StepCountRepository._internal(service);
  }
}
