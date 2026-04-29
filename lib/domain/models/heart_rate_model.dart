class HeartRateEntity {
  final DateTime date;
  final double value;

  HeartRateEntity({required this.date, required this.value});

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }

  factory HeartRateEntity.fromMap(Map<String, dynamic> map) {
    return HeartRateEntity(
      date: DateTime.parse(map['date']),
      value: (map['value'] as num).toDouble(),
    );
  }

  HeartRateEntity copyWith({DateTime? date, double? value}) {
    return HeartRateEntity(date: date ?? this.date, value: value ?? this.value);
  }
}
