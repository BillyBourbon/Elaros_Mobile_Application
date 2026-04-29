import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/intensities_states_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/intensities_repositiory.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/intensities_entity.dart';

class IntensitiesUseCase {
  final IntensitiesRepository intensitiesRepository;

  IntensitiesUseCase({required this.intensitiesRepository});

  Future<IntensityEntity?> getCurrentIntensity() async {
    final latestEntry = await intensitiesRepository.getLatestEntry();

    return latestEntry == null
        ? null
        : IntensityEntity(date: latestEntry.time, value: latestEntry.value);
  }

  Future<List<IntensityEntity>> getAllIntensitiesBetween(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await intensitiesRepository.getRawData(
      start: start,
      end: end,
    );

    return results
        .map((e) => IntensityEntity(date: e.time, value: e.value))
        .toList();
  }

  Future<List<GroupedEntity>> getIntensityGroupedByMinuteBetween(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await intensitiesRepository.getDataGroupedByMinute(
      start: start,
      end: end,
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<List<IntensityStatesModel>> getAllIntensityStates() async {
    final states = await intensitiesRepository.getAllIntensityStates();

    return states;
  }

  Future<String> getReadableIntensityState(IntensityEntity intensity) async {
    final state = intensity.value.toInt();

    final states = await getAllIntensityStates();

    return states.firstWhere((e) => e.id == state).value;
  }
}
