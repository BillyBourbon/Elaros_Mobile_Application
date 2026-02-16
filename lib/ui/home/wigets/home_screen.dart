// home page. routes to the other views.
import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/ui/counter/wigets/counter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CounterScreen()),
                );
              },
              child: const Text('Go to Counter Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
