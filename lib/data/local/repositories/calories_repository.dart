import 'package:elaros_mobile_app/data/local/model/calories_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/base_health_data_repositiory.dart';
import 'package:elaros_mobile_app/data/local/services/calories_service.dart';

class CaloriesRepository
    extends BaseHealthDataRepository<CaloriesModel, CaloriesService> {
  static final CaloriesRepository _instance = CaloriesRepository._internal(
    CaloriesService(),
  );
  factory CaloriesRepository() => _instance;
  CaloriesRepository._internal(super.service);

  factory CaloriesRepository.forTest(CaloriesService service) {
    return CaloriesRepository._internal(service);
  }
}
