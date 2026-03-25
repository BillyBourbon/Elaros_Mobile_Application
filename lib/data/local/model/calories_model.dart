class CaloriesModel {
  final DateTime time;
  final double value;

  CaloriesModel({required this.time, required this.value});

  Map<String, dynamic> toMap() {
    return {'time': time.toIso8601String(), 'value': value};
  }

  factory CaloriesModel.fromMap(Map<String, dynamic> map) {
    return CaloriesModel(
      time: DateTime.parse(map['time']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
