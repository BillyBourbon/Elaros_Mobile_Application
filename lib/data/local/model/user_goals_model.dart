class UserGoalModel {
  String goalName;
  String dataSource;
  int goalValue;

  UserGoalModel({
    required this.goalName,
    required this.dataSource,
    required this.goalValue,
  });

  UserGoalModel.fromMap(Map<String, dynamic> map)
    : goalName = map['goal_name'],
      dataSource = map['data_source'],
      goalValue = map['goal_value'];

  Map<String, dynamic> toMap() {
    return {
      'goal_name': goalName,
      'data_source': dataSource,
      'goal_value': goalValue,
    };
  }
}
