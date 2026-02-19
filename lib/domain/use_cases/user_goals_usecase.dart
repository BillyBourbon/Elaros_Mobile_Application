import 'package:elaros_mobile_app/data/local/model/user_goals_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_goals_repository.dart';
import 'package:elaros_mobile_app/domain/models/user_goals_model.dart';

class UserGoalsUseCase {
  final UserGoalsRepository userGoalsRepository;
  UserGoalsUseCase({required this.userGoalsRepository});

  Future<List<UserGoalEntity>> getUserGoals() async {
    final data = await userGoalsRepository.getUserGoals();

    return data.map((e) => UserGoalEntity.fromMap(e.toMap())).toList();
  }

  Future<void> insertUserGoal(UserGoalEntity userGoal) async {
    await userGoalsRepository.insertUserGoal(
      UserGoalModel.fromMap(userGoal.toMap()),
    );
  }

  Future<void> updateUserGoal(UserGoalEntity userGoal) async {
    await userGoalsRepository.updateUserGoal(
      UserGoalModel.fromMap(userGoal.toMap()),
    );
  }

  Future<void> deleteUserGoal(UserGoalEntity userGoal) async {
    await userGoalsRepository.deleteUserGoal(
      UserGoalModel.fromMap(userGoal.toMap()),
    );
  }
}
