import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  String message = '';
  bool isError = false;
  String errorMessage = '';

  /// Sets the loading state of the view model and resets the view state
  void setLoading() {
    isLoading = true;
    message = '';
    isError = false;
    errorMessage = '';
  }
}
