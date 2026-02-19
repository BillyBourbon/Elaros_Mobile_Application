import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

SnackBar buildErrorSnackBar(BaseViewModel viewModel) {
  return SnackBar(
    content: Text(viewModel.errorMessage),
    backgroundColor: Colors.red,
    duration: const Duration(seconds: 3),
  );
}
