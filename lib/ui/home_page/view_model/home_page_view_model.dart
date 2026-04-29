import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/domain/models/grouped_data_entity.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/calories_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/intensities_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/sleep_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/energy_score_calculator.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_variability_calculator.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_zone_calculator.dart';

class HomePageViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;
  final StepCountUseCase stepCountUseCase;
  final CaloriesUseCase caloriesUseCase;
  final IntensitiesUseCase intensitiesUseCase;
  final SleepUseCase sleepUseCase;

  HomePageViewModel({
    required this.heartRateUseCase,
    required this.stepCountUseCase,
    required this.caloriesUseCase,
    required this.intensitiesUseCase,
    required this.sleepUseCase,
  });

  Future<void> init() async {
    await getLatestHeartRate();
    await getHeartRateLast24Hr();
    await getHaxHeartRateLast24Hr();

    await calculateHRV();

    // await calculateHRZones();
    getHRZoneRanges();

    await getLatestDaysStepCount();

    await getTodaysCalories();

    await calculateEnergyScore();

    await getLastFourWeeksStepCount();

    notifyListeners();
  }

  // ================================ Heart Rate
  HeartRateEntity _currentHeartRate = HeartRateEntity(
    value: 0,
    date: clock.now(),
  );

  HeartRateEntity get currentHeartRate => _currentHeartRate;

  double? _maxHeartRatePast24Hr;

  double get maxHeartRatePast24Hr => _maxHeartRatePast24Hr ?? 0;

  List<GroupedEntity>? _allHeartRatePast24Hr;

  List<GroupedEntity> get allHeartRatePast24Hr => _allHeartRatePast24Hr ?? [];

  Future<void> getLatestHeartRate() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getLatestHeartRate();

      if (data == null) {
        isError = true;
        errorMessage = 'No heart rate data found';
        return;
      }

      _currentHeartRate = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHeartRateLast24Hr() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getGroupedDataByMinute(
        clock.now().subtract(const Duration(days: 1)),
        clock.now(),
      );

      _allHeartRatePast24Hr = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHaxHeartRateLast24Hr() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getGroupedDataByHour(
        clock.now().subtract(const Duration(hours: 24)),
        clock.now(),
      );

      _maxHeartRatePast24Hr = data
          .reduce((prev, curr) => prev.maximum > curr.maximum ? prev : curr)
          .maximum;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ hrv

  HeartRateVariabilityResult? _hrv;

  HeartRateVariabilityResult get hrv =>
      _hrv ?? HeartRateVariabilityResult(rmssd: 0, sdnn: 0, nn50: 0, pnn50: 0);

  Future<void> calculateHRV() async {
    setLoading();
    try {
      if (_maxHeartRatePast24Hr == null) {
        await getHaxHeartRateLast24Hr();
      }

      if (_allHeartRatePast24Hr == null || _allHeartRatePast24Hr!.isEmpty) {
        return;
      }

      final data = await heartRateUseCase.calculateHRV(
        _allHeartRatePast24Hr!
            .map((e) => HeartRateEntity(value: e.median, date: e.time))
            .toList(),
      );

      _hrv = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ hr zones
  List<HeartRateZone>? _hrZoneRanges;

  List<HeartRateZone> get hrZoneRanges => _hrZoneRanges ?? [];

  void getHRZoneRanges() {
    setLoading();
    try {
      final data = heartRateUseCase.calculateHRZoneRanges(maxHeartRatePast24Hr);
      _hrZoneRanges = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ Step Count
  List<GroupedEntity>? _todaysStepCountByHour;
  List<GroupedEntity>? _lastFourWeeksStepData;

  List<GroupedEntity>? get todaysStepCountByHour => _todaysStepCountByHour;
  List<GroupedEntity> get lastFourWeeksStepData => _lastFourWeeksStepData ?? [];

  double get totalDailySteps =>
      (_todaysStepCountByHour == null || _todaysStepCountByHour!.isEmpty)
      ? 0
      : _todaysStepCountByHour!.fold<double>(
          0,
          (previousValue, element) => previousValue + element.total,
        );

  Future<void> getLatestDaysStepCount() async {
    setLoading();
    try {
      final data = await stepCountUseCase.getPast24Hrs();

      if (data.isEmpty) {
        isError = true;
        errorMessage = 'No step count data found';
        return;
      }

      _todaysStepCountByHour = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLastFourWeeksStepCount() async {
    setLoading();
    try {
      final data = await stepCountUseCase.getGroupedDataByDays(days: (4 * 7));

      _lastFourWeeksStepData = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ================================ Calories
  List<GroupedEntity>? _allCaloriesPast24Hr;

  double get totalCalories => _allCaloriesPast24Hr != null
      ? _calculateTotalCalories(_allCaloriesPast24Hr!)
      : 0;

  Future<void> getTodaysCalories() async {
    setLoading();
    try {
      final data = await caloriesUseCase.getPast24Hrs();

      _allCaloriesPast24Hr = data;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double _calculateTotalCalories(List<GroupedEntity> list) {
    return list.fold<double>(
      0,
      (previousValue, element) => previousValue + element.total,
    );
  }

  // ================================ Energy Score
  double _energyScore = 0;

  double get energyScore => _energyScore;

  Future<void> calculateEnergyScore() async {
    setLoading();
    try {
      final start = clock.now().subtract(const Duration(days: 1));
      final end = clock.now();

      final data = await intensitiesUseCase.getAllIntensitiesBetween(
        start,
        end,
      );
      final intensityStates = await intensitiesUseCase.getAllIntensityStates();
      final sleepStates = await sleepUseCase.getAllSleepStates();

      final sleepData = await sleepUseCase.getAllSleepLogsBetween(start, end);
      final sleepStateModels = await sleepUseCase.getAllSleepStates();

      final heartRateData = await heartRateUseCase.getAllHeartRateBetween(
        clock.now().subtract(const Duration(days: 1)),
        clock.now(),
      );

      final caloriesData = await caloriesUseCase.getPast24Hrs();
      final stepCountData = await stepCountUseCase.getPast24Hrs();

      final validHeartRateData = heartRateData ?? [];
      final validSleepData = sleepData;
      final validCaloriesData = caloriesData;
      final validStepCountData = stepCountData;

      final energyScore = EnergyScoreCalculator.calculateEnergyScore(
        weight: 100,
        heartRates: validHeartRateData,
        sleepLogs: validSleepData,
        steps: validStepCountData,
        calories: validCaloriesData,
        intensities: data,
        sleepStates: sleepStateModels,
        intensityStates: intensityStates,
        hrvBaseline: 22,
      );

      _energyScore = energyScore;
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
