import 'package:flutter/material.dart';

String defaultUserId = '1';

List<String> existingGoalDataSources = [
  'StepCount',
  // 'HeartRate',
  // 'CaloriesConsumption',
  // 'Intensities',
  // 'SleepLogs',
];

class DefaultColors {
  static Color red = Colors.red.shade600;
  static Color yellow = Colors.yellow.shade600;
  static Color green = Colors.green.shade600;
  static Color orange = Colors.orange.shade600;
  static Color blue = Colors.blue.shade600;

  static Map<int, Color> hrZoneColourScale = {
    0: DefaultColors.blue,
    1: DefaultColors.green,
    2: DefaultColors.yellow,
    3: DefaultColors.orange,
    4: DefaultColors.red,
  };
}

class DefaultTextStyles {
  static TextStyle defaultTextStyleTitleBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle defaultTextStyleBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static TextStyle defaultTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle defaultTextStyleLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );

  static TextStyle defaultTextStyleAppBar = TextStyle(
    color: Colors.black54,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
}

class DefaultButtonStyles {
  static ButtonStyle elevatedSecondary(ColorScheme colorScheme) =>
      ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      );

  static ButtonStyle normalRed = TextButton.styleFrom(
    backgroundColor: DefaultColors.red,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    textStyle: DefaultTextStyles.defaultTextStyleBold,
  );
}

class HealthTips {
  static const Map<String, String> healthTips = {
    "Stay Hydrated":
        "Drink multiple glasses of water throughout your day. Proper hydration improves energy, brain function, and skin health.",
    "Prioritize Sleeping Well":
        "Aim for 7-9 hours of quality sleep each night. Maintaining a consistent sleep schedule improves mood and cognitive function.",
    "Take Movement Breaks":
        "Stand up and stretch every hour. Prolonged sitting increases risk of back pain and cardiovascular issues.",
    "Be Mindful Of What Your Eating":
        "Eat balanced meals and pay attention to not overeat.",
    "Deep Breathing Exercise":
        "Try the 4-7-8 technique: Inhale 4 sec, hold 7 sec, exhale 8 sec. Reduces stress and anxiety.",
    "Limit Screen Time Before Bed":
        "Avoid screens 1 hour before sleep. Blue light disrupts melatonin production and can interfere with sleep.",
    "Wash Hands Properly":
        "Scrub for at least 20 seconds. Prevents spread of infectious diseases.",
    "Stay Socially Connected":
        "Regular social interaction reduces depression risk and improves cognitive health.",
    "Take Regular Digital Detoxes":
        "Set aside tech-free hours daily. Reduces eye strain and mental fatigue.",
    "Maintain Good Posture":
        "Keep your back straight and shoulders back. Prevents chronic neck and back pain.",
    "Get Regular Health Check-ups":
        "Annual physical exams can catch potential issues early when they're most treatable.",
  };
}
