class UserGoalEntity {
  String goalName;
  String dataSource;
  int goalValue;

  UserGoalEntity({
    required this.goalName,
    required this.dataSource,
    required this.goalValue,
  });

  UserGoalEntity.fromMap(Map<String, dynamic> map)
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

  bool equals(UserGoalEntity other) {
    return goalName == other.goalName &&
        dataSource == other.dataSource &&
        goalValue == other.goalValue;
  }
}
