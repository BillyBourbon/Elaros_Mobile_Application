class StepCountEntity {
  final DateTime date;
  final int value;

  StepCountEntity({required this.date, required this.value});

  StepCountEntity copyWith({DateTime? date, int? value}) {
    return StepCountEntity(date: date ?? this.date, value: value ?? this.value);
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'value': value};
  }

  @override
  String toString() {
    return 'StepCountEntity{date: $date, value: $value}';
  }
}
