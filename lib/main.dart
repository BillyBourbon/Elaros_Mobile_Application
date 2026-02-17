import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'Home_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}
=======
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
>>>>>>> b22b6ceeec5470c5b2d0402bc0b6f475148477b8
