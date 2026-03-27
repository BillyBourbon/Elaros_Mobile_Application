class SleepStatesModel {
  final int id;
  final String value;

  SleepStatesModel({required this.id, required this.value});

  Map<String, dynamic> toMap() {
    return {'id': id, 'value': value};
  }

  factory SleepStatesModel.fromMap(Map<String, dynamic> map) {
    return SleepStatesModel(
      id: (map['id'] as num).toInt(),
      value: map['value'],
    );
  }
}
