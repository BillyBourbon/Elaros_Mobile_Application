import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/domain/models/heart_rate_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';

class TestPageTwoViewModel extends ChangeNotifier {
  final HeartRateUseCase heartRateUseCase;

  List<HeartRateEntity> data = [];

  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';
  String message = '';

  TestPageTwoViewModel({required this.heartRateUseCase});

  Future<void> getHeartRateLastNDays(int days) async {
    isLoading = true;
    notifyListeners();

    try {
      data = await heartRateUseCase.getHeartRateLastNDays(days);
      message = 'Fetched ${data.length} Heart Rates';
    } catch (error) {
      isError = true;
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHeartRateLastNHours(int hours) async {
    isLoading = true;
    notifyListeners();

    try {
      data = await heartRateUseCase.getHeartRateLastNHours(hours);
    } catch (error) {
      isError = true;
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHeartRateBetweenDates(DateTime start, DateTime end) async {
    isLoading = true;
    notifyListeners();

    try {
      data = await heartRateUseCase.getHeartRateBetweenDates(start, end);
    } catch (error) {
      isError = true;
      errorMessage = error.toString();
    } finally {
      notifyListeners();
    }
  }
}
