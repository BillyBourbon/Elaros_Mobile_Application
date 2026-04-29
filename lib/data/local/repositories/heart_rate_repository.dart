import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/base_health_data_repositiory.dart';
import 'package:elaros_mobile_app/data/local/services/heart_rate_service.dart';

class HeartRateRepository
    extends BaseHealthDataRepository<HeartRateModel, HeartRateService> {
  static final HeartRateRepository _instance = HeartRateRepository._internal(
    HeartRateService(),
  );
  factory HeartRateRepository() => _instance;
  HeartRateRepository._internal(super.service);

  factory HeartRateRepository.forTest(HeartRateService service) {
    return HeartRateRepository._internal(service);
  }
}
