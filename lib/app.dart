import 'package:elaros_mobile_app/ui/common/theme/app_theme.dart';
import 'package:elaros_mobile_app/ui/navigation/wigets/navigation.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      home: const HomeScreen(),
    );
  }
}
