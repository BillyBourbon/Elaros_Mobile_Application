import 'package:elaros_mobile_app/data/local/repositories/heart_rate_repository.dart';
import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/ui/test_page_two/view_model/test_page_two_view_model.dart';
import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/app.dart';
import 'package:provider/provider.dart';
import 'package:clock/clock.dart';

void main() {
  withClock(Clock.fixed(DateTime(2016, 5, 12)), () {
    final heartRateRepository = HeartRateRepository();
    final heartRateUseCase = HeartRateUseCase(
      heartRateRepository: heartRateRepository,
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                TestPageTwoViewModel(heartRateUseCase: heartRateUseCase),
          ),
        ],
        child: const App(),
      ),
    );
  });
}
