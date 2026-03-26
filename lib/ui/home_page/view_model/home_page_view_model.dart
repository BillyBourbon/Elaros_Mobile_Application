import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/domain/models/calories_entity.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/models/step_count_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/calories_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class HomePageViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;
  final StepCountUseCase stepCountUseCase;
  final CaloriesUseCase caloriesUseCase;

  HomePageViewModel({
    required this.heartRateUseCase,
    required this.stepCountUseCase,
    required this.caloriesUseCase,
  });

  // ================================ Heart Rate
  HeartRateEntity _heartRate = HeartRateEntity(value: 0, date: clock.now());

  HeartRateEntity get heartRate => _heartRate;

  Future<void> getLatestHeartRate() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getLatestHeartRate();

      if (data == null) {
        isError = true;
        errorMessage = 'No heart rate data found';
        return;
      }

      _heartRate = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ Step Count
  StepCountEntity _stepCount = StepCountEntity(value: 0, date: clock.now());

  StepCountEntity get stepCount => _stepCount;

  Future<void> getLatestStepCount() async {
    setLoading();
    try {
      final data = await stepCountUseCase.getLatestStepCount();

      if (data == null) {
        isError = true;
        errorMessage = 'No step count data found';
        return;
      }

      _stepCount = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ Calories
  CaloriesEntity _calories = CaloriesEntity(value: 0, date: clock.now());

  CaloriesEntity get calories => _calories;

  Future<void> getLatestCalories() async {
    setLoading();
    try {
      final data = await caloriesUseCase.getLatestCalories();

      if (data == null) {
        isError = true;
        errorMessage = 'No calories data found';
        return;
      }

      _calories = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
