import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/intesities_model.dart';
import 'package:elaros_mobile_app/data/local/model/sleep_states_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/base_health_data_repositiory.dart';
import 'package:elaros_mobile_app/data/local/services/intensities_service.dart';
import 'package:elaros_mobile_app/data/local/services/sleep_states_service.dart';

class SleepRepository
    extends BaseHealthDataRepository<SleepModel, SleepService> {
  static final _sleepStatesService = SleepStatesService();

  static final SleepRepository _instance = SleepRepository._internal(
    SleepService(),
  );

  factory SleepRepository() => _instance;
  SleepRepository._internal(super.service);

  factory SleepRepository.forTest(SleepService service) {
    return SleepRepository._internal(service);
  }

  // States Cache
  DateTime? lastUpdated;
  List<SleepStatesModel> intensityStates = [];

  /// Get intensity states
  Future<List<SleepStatesModel>> getAllSleepStates() async {
    if (lastUpdated != null &&
        clock.now().difference(lastUpdated!) < const Duration(minutes: 10)) {
      return intensityStates;
    }

    final states = await _sleepStatesService.getSleepStates();

    intensityStates = states;
    lastUpdated = clock.now();

    return states;
  }
}
