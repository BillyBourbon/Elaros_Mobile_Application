class UserGoalEntity {
  String goalName;
  String dataSource;
  num goalValue;
  num currentValue;

  UserGoalEntity({
    required this.goalName,
    required this.dataSource,
    required this.goalValue,
    this.currentValue = 0,
  });

  UserGoalEntity.fromMap(Map<String, dynamic> map)
    : goalName = map['goalName'],
      dataSource = map['dataSource'],
      goalValue = map['goalValue'] as num,
      currentValue = map['currentValue'] as num;

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'dataSource': dataSource,
      'goalValue': goalValue,
      'currentValue': currentValue,
    };
  }

  bool equals(UserGoalEntity other) {
    return goalName == other.goalName &&
        dataSource == other.dataSource &&
        goalValue == other.goalValue &&
        currentValue == other.currentValue;
  }
}
