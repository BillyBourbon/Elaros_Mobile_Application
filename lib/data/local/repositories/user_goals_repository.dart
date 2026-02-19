import 'package:elaros_mobile_app/data/local/model/user_goals_model.dart';
import 'package:elaros_mobile_app/data/local/services/user_goals_service.dart';

class UserGoalsRepository {
  final UserGoalsService _userGoalsService;
  static final UserGoalsRepository _instance = UserGoalsRepository._internal(
    UserGoalsService(),
  );
  factory UserGoalsRepository() => _instance;
  UserGoalsRepository._internal(this._userGoalsService);

  factory UserGoalsRepository.forTest(UserGoalsService service) {
    return UserGoalsRepository._internal(service);
  }

  Future<List<UserGoalModel>> getUserGoals() async {
    final data = await _userGoalsService.getUserGoals();

    return data.map((e) => UserGoalModel.fromMap(e)).toList();
  }

  Future<void> insertUserGoal(UserGoalModel userGoal) async {
    await _userGoalsService.insertUserGoal(userGoal);
  }

  Future<void> updateUserGoal(UserGoalModel userGoal) async {
    await _userGoalsService.updateUserGoal(userGoal);
  }
  Future<void> deleteUserGoal(UserGoalModel userGoal) async {
    await _userGoalsService.deleteUserGoal(userGoal);
  }
}
