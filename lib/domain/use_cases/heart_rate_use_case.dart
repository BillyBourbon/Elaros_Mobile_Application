import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_profile_repository.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/user_profile_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_zone_calculator.dart';

class HeartRateUseCase {
  final HeartRateRepository _repository;
  final UserProfileRepository _userProfileRepository;

  HeartRateUseCase(this._repository, this._userProfileRepository);

  Future<HeartRateEntity?> getLatestHeartRate() async {
    final HeartRateModel? latestEntry = await _repository.getLatestEntry();

    return latestEntry == null
        ? null
        : HeartRateEntity(date: latestEntry.time, value: latestEntry.value);
  }

  Future<List<HeartRateEntity>?> getAllHeartRateBetween(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await _repository.getRawData(start: start, end: end);

    return results
        .map((e) => HeartRateEntity(date: e.time, value: e.value))
        .toList();
  }

  Future<List<GroupedEntity>> getGroupedDataByMinute(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await _repository.getDataGroupedByMinute(
      start: start,
      end: end,
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<List<GroupedEntity>> getGroupedDataByHour(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await _repository.getDataGroupedByHour(
      start: start,
      end: end,
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<List<GroupedEntity>> getGroupedDataByDay(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await _repository.getDataGroupedByDay(
      start: start,
      end: end,
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<List<GroupedEntity>> getGroupedDataByMonth(
    DateTime start,
    DateTime? end,
  ) async {
    end ??= clock.now();
    final results = await _repository.getDataGroupedByMonth(
      start: start,
      end: end,
    );

    return results.map((e) => GroupedEntity.fromMap(e.toMap())).toList();
  }

  Future<HeartRateVariabilityResult> calculateHRV(
    List<HeartRateEntity> list,
  ) async {
    return HeartRateVariabilityCalculator.calculateAll(list);
  }

  Future<HeartRateZoneResult> calculateHRZones(
    List<HeartRateEntity> list,
    double maxHeartRate,
  ) async {
    UserProfileEntity userProfile = await _getUserProfile();

    return HeartRateZoneCalculator.calculateZones(
      data: list,
      current: HeartRateEntity(value: list.last.value, date: clock.now()),
      userProfile: userProfile,
      hrv: await calculateHRV(list),
      maxHeartRate: maxHeartRate,
    );
  }

  List<HeartRateZone> calculateHRZoneRanges(double maxHeartRate) {
    return HeartRateZoneCalculator.buildZones(maxHeartRate);
  }

  Future<UserProfileEntity> _getUserProfile() async {
    final profile = await _userProfileRepository.getUserProfile();
    return UserProfileEntity.fromMap(profile.first.toMap());
  }
}
