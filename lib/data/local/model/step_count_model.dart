class StepCountModel {
  final DateTime date;
  final int totalSteps;

  StepCountModel({required this.date, required this.totalSteps});

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'totalSteps': totalSteps};
  }

  factory StepCountModel.fromMap(Map<String, dynamic> map) {
    return StepCountModel(
      date: DateTime.parse(map['day']),
      totalSteps: (map['total_steps'] as int),
    );
  }
}
