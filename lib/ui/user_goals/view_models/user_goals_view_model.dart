import 'package:elaros_mobile_app/domain/models/user_goals_model.dart';
import 'package:elaros_mobile_app/domain/use_cases/user_goals_usecase.dart';
import 'package:elaros_mobile_app/ui/common/widgets/view_models/base_view_model.dart';

class UserGoalsViewModel extends BaseViewModel {
  final UserGoalsUseCase userGoalsUseCase;

  List<UserGoalEntity> userGoals = [];

  UserGoalsViewModel({required this.userGoalsUseCase});

  /// Fetches the user goals
  Future<void> getUserGoals({bool isInitialLoad = false}) async {
    setLoading();

    try {
      final data = await userGoalsUseCase.getUserGoals();
      userGoals = data;
      if (!isInitialLoad) message = 'Successfully fetched user goals';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertUserGoal(UserGoalEntity userGoal) async {
    setLoading();

    try {
      await userGoalsUseCase.insertUserGoal(userGoal);
      message = 'Successfully inserted user goal';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateUserGoal(UserGoalEntity userGoal) async {
    setLoading();

    try {
      await userGoalsUseCase.updateUserGoal(userGoal);
      message = 'Successfully updated user goal';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // DELETEs
  Future<void> deleteUserGoal(UserGoalEntity userGoal) async {
    setLoading();

    try {
      await userGoalsUseCase.deleteUserGoal(userGoal);
      message = 'Successfully deleted user goal';
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
