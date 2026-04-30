import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/app.dart';
import 'package:elaros_mobile_app/data/local/repositories/calories_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/intensities_repositiory.dart';
import 'package:elaros_mobile_app/data/local/repositories/sleep_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_goals_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_profile_repository.dart';
import 'package:elaros_mobile_app/domain/use_cases/calories_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/intensities_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/profile_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/sleep_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/user_goals_usecase.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/view_models/hr_zone_view_model.dart';
import 'package:elaros_mobile_app/ui/profile_page/view_model/profile_page_view_model.dart';
import 'package:elaros_mobile_app/ui/test_page_three/view_model/test_page_three_view_model.dart';
import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  withClock(Clock.fixed(DateTime(2016, 5, 11, 1)), () {
    final userProfileRepository = UserProfileRepository();
    final profileUseCase = ProfileUseCase(
      userProfileRepository: userProfileRepository,
    );

    final userGoalsRepository = UserGoalsRepository();
    final userGoalsUseCase = UserGoalsUseCase(
      userGoalsRepository: userGoalsRepository,
    );

    final heartRateRepository = HeartRateRepository();
    final heartRateUseCase = HeartRateUseCase(
      heartRateRepository,
      userProfileRepository,
    );

    final stepCountRepository = StepCountRepository();
    final stepCountUseCase = StepCountUseCase(
      stepCountRepository: stepCountRepository,
    );

    final caloriesRepository = CaloriesRepository();
    final caloriesUseCase = CaloriesUseCase(
      caloriesRepository: caloriesRepository,
    );

    final intensitiesRepository = IntensitiesRepository();
    final intensitiesUseCase = IntensitiesUseCase(
      intensitiesRepository: intensitiesRepository,
    );

    final sleepRepository = SleepRepository();
    final sleepUseCase = SleepUseCase(sleepRepository: sleepRepository);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProfilePageViewModel(profileUseCase: profileUseCase),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                UserGoalsViewModel(userGoalsUseCase: userGoalsUseCase),
          ),
          ChangeNotifierProvider(
            create: (_) => TestPageThreeViewModel(
              heartRateUseCase: heartRateUseCase,
              stepCountUseCase: stepCountUseCase,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => HomePageViewModel(
              heartRateUseCase: heartRateUseCase,
              stepCountUseCase: stepCountUseCase,
              caloriesUseCase: caloriesUseCase,
              intensitiesUseCase: intensitiesUseCase,
              sleepUseCase: sleepUseCase,
              userProfileUseCase: profileUseCase,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => HrZoneViewModel(heartRateUseCase: heartRateUseCase),
          ),
        ],
        child: const App(),
      ),
    );
  });
}
