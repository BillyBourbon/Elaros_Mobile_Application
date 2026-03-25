class IntensitiesModel {
  final DateTime time;
  final double value;

  IntensitiesModel({required this.time, required this.value});

  Map<String, dynamic> toMap() {
    return {'time': time.toIso8601String(), 'value': value};
  }

  factory IntensitiesModel.fromMap(Map<String, dynamic> map) {
    return IntensitiesModel(
      time: DateTime.parse(map['time']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
