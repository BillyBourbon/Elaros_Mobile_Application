import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_zone_calculator.dart';

class HrZoneViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;

  HrZoneViewModel({required this.heartRateUseCase});

  GroupedEntity? _lastMonthHeartRate;

  GroupedEntity get lastMonthHeartRate =>
      _lastMonthHeartRate ??
      GroupedEntity(
        time: clock.now(),
        entries: 0,
        total: 0,
        first: 0,
        last: 0,
        maximum: 0,
        minimum: 0,
        average: 0,
        median: 0,
      );

  double _maxHeartRate = 190;
  double _restingHeartRate = 60;

  double get maxHeartRate => _maxHeartRate;
  double get restingHeartRate => _restingHeartRate;

  List<HeartRateZone>? _hrZoneRanges;

  List<HeartRateZone> get hrZoneRanges => _hrZoneRanges ?? [];

  Future<void> getHRZoneRanges() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getGroupedDataByMonth(
        clock.now().subtract(const Duration(days: 31)),
        clock.now(),
      );

      _lastMonthHeartRate = data.first;

      _maxHeartRate = lastMonthHeartRate.maximum;
      _restingHeartRate = lastMonthHeartRate.average;

      final ranges = heartRateUseCase.calculateHRZoneRanges(maxHeartRate);
      ranges.sort((a, b) => a.min.compareTo(b.min));

      _hrZoneRanges = ranges;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
