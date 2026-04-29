class IntensityEntity {
  final DateTime date;
  final double value;

  IntensityEntity({required this.date, required this.value});

  factory IntensityEntity.fromMap(Map<String, dynamic> map) {
    return IntensityEntity(
      date: DateTime.parse(map['date']),
      value: map['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }
}
