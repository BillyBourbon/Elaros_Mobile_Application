import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/data/local/model/grouped_model.dart';
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
    final goalList = await _userGoalsService.getUserGoals();

    if (goalList.isEmpty) return [];

    for (var goal in goalList) {
      if (existingGoalDataSources.contains(goal.dataSource)) {
        List<GroupedModel> d = await _stepCountRepository.getDataGroupedByDay(
          start: clock.now().subtract(Duration(days: 7)),
          end: clock.now(),
        );

        d.sort((a, b) => a.time.compareTo(b.time));

        goal.currentValue = d.last.total;
      }
    }

    return goalList;
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
