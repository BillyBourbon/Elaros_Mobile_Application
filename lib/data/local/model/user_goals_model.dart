class UserGoalModel {
  String goalName;
  String dataSource;
  num goalValue;
  num? currentValue;

  UserGoalModel({
    required this.goalName,
    required this.dataSource,
    required this.goalValue,
    this.currentValue = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'dataSource': dataSource,
      'goalValue': goalValue,
      'currentValue': currentValue,
    };
  }

  factory UserGoalModel.fromMap(Map<String, dynamic> map) {
    return UserGoalModel(
      goalName: map['goalName'],
      dataSource: map['dataSource'],
      goalValue: map['goalValue'] as num,
      currentValue: map['currentValue'] as num?,
    );
  }
}
