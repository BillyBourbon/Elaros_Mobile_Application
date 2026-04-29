class SleepModel {
  final DateTime time;
  final double value;

  SleepModel({required this.time, required this.value});

  Map<String, dynamic> toMap() {
    return {'time': time.toIso8601String(), 'value': value};
  }

  factory SleepModel.fromMap(Map<String, dynamic> map) {
    return SleepModel(
      time: DateTime.parse(map['time']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
