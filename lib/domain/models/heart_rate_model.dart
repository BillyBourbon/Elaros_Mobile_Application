class HeartRateEntity {
  final DateTime date;
  final double value;

  HeartRateEntity({required this.date, required this.value});

  HeartRateEntity copyWith({DateTime? date, double? value}) {
    return HeartRateEntity(date: date ?? this.date, value: value ?? this.value);
  }
}
