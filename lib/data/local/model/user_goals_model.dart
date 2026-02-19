class UserGoalModel {
  String goalName;
  String dataSource;
  int goalValue;
  int? currentValue;

  UserGoalModel({
    required this.goalName,
    required this.dataSource,
    required this.goalValue,
    this.currentValue = 0,
  });

  UserGoalModel.fromMap(Map<String, dynamic> map)
    : goalName = map['goalName'],
      dataSource = map['dataSource'],
      goalValue = map['goalValue'],
      currentValue = map['currentValue'];

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'dataSource': dataSource,
      'goalValue': goalValue,
      'currentValue': currentValue ?? 0,
    };
  }
}
