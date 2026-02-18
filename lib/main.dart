import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/app.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/counter/view_models/counter_view_model.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterViewModel(counter: 0),
      child: const App(),
    ),
  );
}