import 'package:elaros_mobile_app/domain/use_cases/step_count_use_case.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreenStepCount extends StatefulWidget {
  final HomePageViewModel homePageViewModel;
  const InsightsScreenStepCount({super.key, required this.homePageViewModel});

  @override
  State<InsightsScreenStepCount> createState() =>
      _InsightsScreenStepCountState();
}

class _InsightsScreenStepCountState extends State<InsightsScreenStepCount> {
  late StepCountUseCase stepCountUseCase;

  @override
  void initState() {
    super.initState();

    stepCountUseCase = context.read<StepCountUseCase>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return _buildBody(viewModel);
      },
    );
  }

  Widget _buildBody(HomePageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text('Step Count Insights')],
    );
  }
}
