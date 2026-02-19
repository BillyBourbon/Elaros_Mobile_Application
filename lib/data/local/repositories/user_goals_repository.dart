import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/data/local/model/user_goals_model.dart';
import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
import 'package:elaros_mobile_app/data/local/services/user_goals_service.dart';

class UserGoalsRepository {
  final UserGoalsService _userGoalsService;
  final StepCountRepository _stepCountRepository;

  static final UserGoalsRepository _instance = UserGoalsRepository._internal(
    UserGoalsService(),
    StepCountRepository(),
  );
  factory UserGoalsRepository() => _instance;
  UserGoalsRepository._internal(
    this._userGoalsService,
    this._stepCountRepository,
  );

  factory UserGoalsRepository.forTest(
    UserGoalsService userGoalService,
    StepCountRepository stepCountRepository,
  ) {
    return UserGoalsRepository._internal(userGoalService, stepCountRepository);
  }

  Future<List<UserGoalModel>> getUserGoals() async {
    final data = await _userGoalsService.getUserGoals();

    if (data.isEmpty) return [];

    final mapped = data.map((e) => UserGoalModel.fromMap(e)).toList();

    for (var e in mapped) {
      if (existingGoalDataSources.contains(e.dataSource)) {
        var data = await _stepCountRepository.getStepCountByDayLastNDays(1);

        data.sort((a, b) => a.date.compareTo(b.date));

        e.currentValue = data.last.totalSteps;
      }
    }

    return mapped;
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
