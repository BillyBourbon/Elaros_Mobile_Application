import 'package:flutter/material.dart';
import 'ui/notification/notification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationPage(), // ✅ Add NotificationPage here
    );
  }
}
