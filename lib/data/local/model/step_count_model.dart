class StepCountModel {
  final DateTime time;
  final int value;

  StepCountModel({required this.time, required this.value});

  Map<String, dynamic> toMap() {
    return {'time': time.toIso8601String(), 'value': value};
  }

  factory StepCountModel.fromMap(Map<String, dynamic> map) {
    return StepCountModel(
      time: DateTime.parse(map['time']),
      value: (map['value'] as int),
    );
  }
}
