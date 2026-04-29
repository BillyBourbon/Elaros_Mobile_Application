import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/step_count_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class TestPageThreeViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;
  final StepCountUseCase stepCountUseCase;

  List<HeartRateEntity> data = [];
  List<StepCountEntity> stepCountData = [];
  List<Map<String, dynamic>> groupedData = [];

  TestPageThreeViewModel({
    required this.heartRateUseCase,
    required this.stepCountUseCase,
  });

  Future<void> getLatestHeartRate() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await heartRateUseCase.getLatestHeartRate();
      data = [result!];
      message = 'Fetched Latest Heart Rate';
    } catch (error) {
      isError = true;
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLastHourOfMinuteData() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await heartRateUseCase.getGroupedDataByMinute(
        clock.now().subtract(Duration(hours: 1)),
        clock.now(),
      );

      groupedData = result.toList().map((e) => e.toMap()).toList();
      message = 'Fetched Last Hour of Minute Data';
    }
    // catch (error) {
    //   isError = true;
    //   errorMessage = error.toString();
    // }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLatestStepCount() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await stepCountUseCase.getLatestStepCount();
      stepCountData = [result!];
      message = 'Fetched Latest Step Count';
    }
    // catch (error) {
    //   isError = true;
    //   errorMessage = error.toString();
    // }
    finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
