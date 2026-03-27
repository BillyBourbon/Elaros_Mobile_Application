import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/sleep_states_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/sleep_repository.dart';
import 'package:elaros_mobile_app/domain/models/sleep_entity.dart';

class SleepUseCase {
  final SleepRepository sleepRepository;

  SleepUseCase({required this.sleepRepository});

  Future<List<SleepStatesModel>> getAllSleepStates() async {
    final states = await sleepRepository.getAllSleepStates();

    return states;
  }

  Future<List<SleepEntity>> getAllSleepLogsBetween(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await sleepRepository.getRawData(start: start, end: end);

    return results
        .map((e) => SleepEntity(date: e.time, value: e.value))
        .toList();
  }
}
