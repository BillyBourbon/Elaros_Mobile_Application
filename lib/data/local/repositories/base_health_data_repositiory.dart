import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/data/local/model/grouped_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';

abstract class BaseHealthDataRepository<
  RawModel,
  Service extends BaseHealthDataService<RawModel>
> {
  final Service _service;

  BaseHealthDataRepository(this._service);

  Future<RawModel?> getLatestEntry() async {
    return _service.getLatestEntry();
  }

  Future<List<RawModel>> getRawData({
    required DateTime start,
    DateTime? end,
  }) async {
    end ??= clock.now();
    return _service.getRawData(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByMinute({
    required DateTime start,
    DateTime? end,
  }) async {
    end ??= clock.now();
    return _service.getRawDataGroupedByMinute(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByHour({
    required DateTime start,
    DateTime? end,
  }) async {
    end ??= clock.now();
    return _service.getGroupedDataByHour(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByDay({
    required DateTime start,
    DateTime? end,
  }) async {
    end ??= clock.now();
    return _service.getGroupedDataByDay(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByMonth({
    required DateTime start,
    DateTime? end,
  }) async {
    end ??= clock.now();
    return _service.getGroupedDataByMonth(start, end);
  }
}
