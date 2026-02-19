import 'package:flutter/material.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to the Elaros Mobile Health App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
                'This will have data, (like HR Zones, and step count displayed in graphs, just having some DB connectivity issues right now)',
                textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
