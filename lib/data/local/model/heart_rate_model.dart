class HeartRateModel {
  final DateTime time;
  final double value;

  HeartRateModel({required this.time, required this.value});

  Map<String, dynamic> toMap() {
    return {'time': time.toIso8601String(), 'value': value};
  }

  factory HeartRateModel.fromMap(Map<String, dynamic> map) {
    return HeartRateModel(
      time: DateTime.parse(map['time']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
