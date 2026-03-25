import 'package:elaros_mobile_app/data/local/model/grouped_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';

class BaseHealthDataRepository<
  RawModel,
  Service extends BaseHealthDataService<RawModel>
> {
  final Service _service;

  BaseHealthDataRepository(this._service);

  Future<RawModel?> getLatestEntry() async {
    return _service.getLatestEntry();
  }

  Future<List<RawModel>> getRawData(DateTime start, DateTime? end) async {
    return _service.getRawData(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByMinute(
    DateTime start,
    DateTime? end,
  ) async {
    return _service.getRawDataGroupedByMinute(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByHour(
    DateTime start,
    DateTime? end,
  ) async {
    return _service.getGroupedDataByHour(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByDay(
    DateTime start,
    DateTime? end,
  ) async {
    return _service.getGroupedDataByDay(start, end);
  }

  Future<List<GroupedModel>> getDataGroupedByMonth(
    DateTime start,
    DateTime? end,
  ) async {
    return _service.getGroupedDataByMonth(start, end);
  }
}
