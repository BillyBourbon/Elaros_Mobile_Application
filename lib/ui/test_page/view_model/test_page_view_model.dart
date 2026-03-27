import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class TestPageViewModel extends BaseViewModel {
  final HeartRateUseCase heartRateUseCase;
  TestPageViewModel({required this.heartRateUseCase});

  List<Map<String, dynamic>>? _allHeartRatePast24Hr;

  List<Map<String, dynamic>> get allHeartRatePast24Hr =>
      _allHeartRatePast24Hr ?? [];

  Future<void> getLineData() async {
    setLoading();
    try {
      final data = await heartRateUseCase.getGroupedDataByHour(
        clock.now().subtract(const Duration(days: 1)),
        clock.now(),
      );

      _allHeartRatePast24Hr = data
          .map((e) => {"value": e.average, "date": e.time})
          .toList();

      log(data.toString());

      _allHeartRatePast24Hr?.forEach((e) => log(e.toString()));
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
