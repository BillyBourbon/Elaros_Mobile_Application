import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

SnackBar buildSuccessSnackBar(BaseViewModel viewModel) {
  return SnackBar(
    content: Text(viewModel.message),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 3),
  );
}
