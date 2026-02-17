import 'package:flutter/material.dart';
import '../services/database_helper.dart'; // Import your helper
import '../models/heart_rate.dart';

class MetricsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ... Other UI elements (Today's Overview, etc.) ...

          // Example: The "Avg HR" Card from your Figma
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FutureBuilder<List<HeartRate>>(
              future: DatabaseHelper.instance.getAllHeartRates(),
              builder: (context, snapshot) {
                // 1. While waiting for the DB to respond
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // 2. If there's an error
                if (snapshot.hasError) {
                  return Text("Error loading data");
                }

                // 3. If data is empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("-- bpm");
                }

                // 4. Calculate Average (from your SQL data)
                final heartRates = snapshot.data!;
                final avg =
                    heartRates.map((m) => m.value).reduce((a, b) => a + b) /
                    heartRates.length;

                return Column(
                  children: [
                    Text("Avg HR", style: TextStyle(color: Colors.grey)),
                    Text(
                      "${avg.toStringAsFixed(0)} bpm",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
