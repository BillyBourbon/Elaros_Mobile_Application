import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/intensities_states_model.dart';
import 'package:elaros_mobile_app/data/local/model/intesities_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/base_health_data_repositiory.dart';
import 'package:elaros_mobile_app/data/local/services/intensities_service.dart';
import 'package:elaros_mobile_app/data/local/services/intensities_states_service.dart';

class IntensitiesRepository
    extends BaseHealthDataRepository<IntensitiesModel, IntensitiesService> {
  static final _intensityStatesService = IntensitiesStatesService();

  static final IntensitiesRepository _instance =
      IntensitiesRepository._internal(IntensitiesService());

  factory IntensitiesRepository() => _instance;
  IntensitiesRepository._internal(super.service);

  factory IntensitiesRepository.forTest(IntensitiesService service) {
    return IntensitiesRepository._internal(service);
  }

  // States Cache
  DateTime? lastUpdated;
  List<IntensityStatesModel> intensityStates = [];

  /// Get intensity states
  Future<List<IntensityStatesModel>> getAllIntensityStates() async {
    if (lastUpdated != null &&
        clock.now().difference(lastUpdated!) < const Duration(minutes: 10)) {
      return intensityStates;
    }

    final states = await _intensityStatesService.getIntensityStates();

    intensityStates = states;
    lastUpdated = clock.now();

    return states;
  }
}
