class GroupedEntity {
  final DateTime time;
  final int entries;
  final double first;
  final double last;
  final double maximum;
  final double minimum;
  final double average;
  final double median;

  GroupedEntity({
    required this.time,
    required this.entries,
    required this.first,
    required this.last,
    required this.maximum,
    required this.minimum,
    required this.average,
    required this.median,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time.toIso8601String(),
      'entries': entries,
      'first': first,
      'last': last,
      'maximum': maximum,
      'minimum': minimum,
      'average': average,
      'median': median,
    };
  }

  factory GroupedEntity.fromMap(Map<String, dynamic> map) {
    return GroupedEntity(
      time: DateTime.parse(map['time']),
      entries: (map['entries'] as num).toInt(),
      first: (map['first'] as num).toDouble(),
      last: (map['last'] as num).toDouble(),
      maximum: (map['maximum'] as num).toDouble(),
      minimum: (map['minimum'] as num).toDouble(),
      average: (map['average'] as num).toDouble(),
      median: (map['median'] as num).toDouble(),
    );
  }

  GroupedEntity copyWith({
    DateTime? time,
    int? entries,
    double? first,
    double? last,
    double? maximum,
    double? minimum,
    double? average,
    double? median,
  }) {
    return GroupedEntity(
      time: time ?? this.time,
      entries: entries ?? this.entries,
      first: first ?? this.first,
      last: last ?? this.last,
      maximum: maximum ?? this.maximum,
      minimum: minimum ?? this.minimum,
      average: average ?? this.average,
      median: median ?? this.median,
    );
  }
}
