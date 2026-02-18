class HeartRate {
  final int id;
  final String time;
  final int value;

  HeartRate({required this.id, required this.time, required this.value});

  factory HeartRate.fromMap(Map<String, dynamic> map) {
    return HeartRate(
      id: map['id'] as int,
      time: map['time'] as String? ?? map['timestamp'] as String? ?? '',
      value: map['value'] as int,
    );
  }
}
