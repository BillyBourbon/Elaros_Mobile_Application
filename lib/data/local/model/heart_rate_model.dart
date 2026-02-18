class HeartRateModel {
  final int id;
  final DateTime date;
  final double value;

  HeartRateModel({required this.id, required this.date, required this.value});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date.toIso8601String(), 'value': value};
  }

  factory HeartRateModel.fromMap(Map<String, dynamic> map) {
    return HeartRateModel(
      id: map['id'] as int,
      date: DateTime.parse(map['date']),
      value: (map['value'] as num).toDouble(),
    );
  }
}
