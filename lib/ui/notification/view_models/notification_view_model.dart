import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';

class NotificationViewModel extends ChangeNotifier {
  List<AppNotification> notifications = [];
  int currentHeartRate = 120;
  int maxHeartRate = 160;
  DateTime lastActivity = DateTime.now();
  Timer? inactivityTimer;
  Timer? heartRateTimer;

  NotificationViewModel() {
    startInactivityTimer();
    simulateHeartRate();
  }

  // Heart Rate Zone
  String getHeartRateZone(int hr) {
    double percent = hr / maxHeartRate * 100;
    if (percent < 50) return "Rest";
    if (percent < 60) return "Light";
    if (percent < 70) return "Moderate";
    if (percent < 85) return "High";
    return "Max";
  }

  // Check Heart Rate
  void checkHeartRate(BuildContext context) {
    String zone = getHeartRateZone(currentHeartRate);
    if (zone == "High" || zone == "Max") {
      addNotification(
        type: "warning",
        title: "High Heart Rate",
        message: "Your HR is $currentHeartRate bpm. Slow down!",
      );
      showAlert(
        context,
        " High Heart Rate",
        "Your HR is $currentHeartRate bpm. Slow down!",
      );
    }
  }

  // Inactivity
  void startInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (DateTime.now().difference(lastActivity).inSeconds > 20) {
        addNotification(
          type: "info",
          title: "Time to Move",
          message: "You have been inactive for a while.",
        );
      }
    });
  }

  void userDidSomething() {
    lastActivity = DateTime.now();
  }

  // Add notification
  void addNotification({
    required String type,
    required String title,
    required String message,
  }) {
    notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        title: title,
        message: message,
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void showAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Simulate HR
  void simulateHeartRate() {
    heartRateTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      currentHeartRate = 100 + (20 + DateTime.now().second % 40);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    inactivityTimer?.cancel();
    heartRateTimer?.cancel();
    super.dispose();
  }
}
