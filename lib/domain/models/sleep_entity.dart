class SleepEntity {
  final DateTime date;
  final double value;

  SleepEntity({required this.date, required this.value});

  factory SleepEntity.fromMap(Map<String, dynamic> map) {
    return SleepEntity(date: DateTime.parse(map['date']), value: map['value']);
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }
}
