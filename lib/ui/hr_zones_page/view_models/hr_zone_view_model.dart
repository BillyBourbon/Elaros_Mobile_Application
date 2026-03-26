import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class HrZoneViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;

  HrZoneViewModel({required this.heartRateUseCase});

  final double _maxHeartRate = 190;
  double _restingHeartRate = 60;
int get zone1Min => (_maxHeartRate * 0.50).round();
int get zone1Max => (_maxHeartRate * 0.60).round();

int get zone2Min => (_maxHeartRate * 0.60).round();
int get zone2Max => (_maxHeartRate * 0.70).round();

int get zone3Min => (_maxHeartRate * 0.70).round();
int get zone3Max => (_maxHeartRate * 0.80).round();

int get zone4Min => (_maxHeartRate * 0.80).round();
int get zone4Max => (_maxHeartRate * 0.90).round();

int get zone5Min => (_maxHeartRate * 0.90).round();
int get zone5Max => _maxHeartRate.round();
  double get maxHeartRate => _maxHeartRate;
  double get restingHeartRate => _restingHeartRate;

  Future<void> loadHrZoneData({bool isInitialLoad = false}) async {
    setLoading();

    try {
      final latestHeartRate = await heartRateUseCase.getLatestHeartRate();

      if (latestHeartRate != null) {
        _restingHeartRate = latestHeartRate.value;
      }

      if (!isInitialLoad) {
        message = 'Heart rate data loaded successfully';
      }
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
