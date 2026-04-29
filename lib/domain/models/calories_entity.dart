class CaloriesEntity {
  final DateTime date;
  final double value;

  CaloriesEntity({required this.date, required this.value});

  factory CaloriesEntity.fromMap(Map<String, dynamic> map) {
    return CaloriesEntity(
      date: DateTime.parse(map['date']),
      value: map['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }
}
