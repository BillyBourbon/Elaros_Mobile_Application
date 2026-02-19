class HeartRateModel {
  final int id;
  final DateTime timestamp;
  final double value;

  HeartRateModel({
    required this.id,
    required this.timestamp,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'timestamp': timestamp.toIso8601String(), 'value': value};
  }

  factory HeartRateModel.fromMap(Map<String, dynamic> map) {
    return HeartRateModel(
      id: map['id'] as int,
      timestamp: DateTime.parse(map['timestamp']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
