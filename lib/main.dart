import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/app.dart';
import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/step_count_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_goals_repository.dart';
import 'package:elaros_mobile_app/data/local/repositories/user_profile_repository.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/profile_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/domain/use_cases/user_goals_usecase.dart';
import 'package:elaros_mobile_app/ui/profile_page/view_model/profile_page_view_model.dart';
import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/view_models/hr_zone_view_model.dart';

void main() {
  withClock(Clock.fixed(DateTime(2016, 5, 12)), () {
    final heartRateRepository = HeartRateRepository();
    final heartRateUseCase = HeartRateUseCase(heartRateRepository);

    final stepCountRepository = StepCountRepository();
    final stepCountUseCase = StepCountUseCase(
      stepCountRepository: stepCountRepository,
    );

    final userProfileRepository = UserProfileRepository();
    final profileUseCase = ProfileUseCase(
      userProfileRepository: userProfileRepository,
    );

    final userGoalsRepository = UserGoalsRepository();
    final userGoalsUseCase = UserGoalsUseCase(
      userGoalsRepository: userGoalsRepository,
    );

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
  create: (_) => HrZoneViewModel(heartRateUseCase: heartRateUseCase),
),
        ],
        child: const App(),
      ),
    );
  });
}
