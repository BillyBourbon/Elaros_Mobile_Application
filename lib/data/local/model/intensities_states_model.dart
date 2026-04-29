class IntensityStatesModel {
  final int id;
  final String value;

  IntensityStatesModel({required this.id, required this.value});

  Map<String, dynamic> toMap() {
    return {'id': id, 'value': value};
  }

  factory IntensityStatesModel.fromMap(Map<String, dynamic> map) {
    return IntensityStatesModel(
      id: (map['id'] as num).toInt(),
      value: map['value'],
    );
  }
}
