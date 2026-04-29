class GroupedModel {
  final DateTime time;
  final int entries;
  final double total;
  final double first;
  final double last;
  final double maximum;
  final double minimum;
  final double average;
  final double median;

  GroupedModel({
    required this.time,
    required this.entries,
    required this.total,
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
      'total': total,
      'first': first,
      'last': last,
      'maximum': maximum,
      'minimum': minimum,
      'average': average,
      'median': median,
    };
  }

  factory GroupedModel.fromMap(Map<String, dynamic> map) {
    return GroupedModel(
      time: DateTime.parse(map['time']),
      entries: (map['entries'] as num).toInt(),
      total: (map['total'] as num).toDouble(),
      first: (map['first'] as num).toDouble(),
      last: (map['last'] as num).toDouble(),
      maximum: (map['maximum'] as num).toDouble(),
      minimum: (map['minimum'] as num).toDouble(),
      average: (map['average'] as num).toDouble(),
      median: (map['median'] as num).toDouble(),
    );
  }

  GroupedModel copyWith({
    DateTime? time,
    int? entries,
    double? total,
    double? first,
    double? last,
    double? maximum,
    double? minimum,
    double? average,
    double? median,
  }) {
    return GroupedModel(
      time: time ?? this.time,
      entries: entries ?? this.entries,
      total: total ?? this.total,
      first: first ?? this.first,
      last: last ?? this.last,
      maximum: maximum ?? this.maximum,
      minimum: minimum ?? this.minimum,
      average: average ?? this.average,
      median: median ?? this.median,
    );
  }
}
