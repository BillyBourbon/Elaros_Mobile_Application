import 'package:elaros_mobile_app/domain/use_cases/calories_use_case.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreenCalories extends StatefulWidget {
  final HomePageViewModel homePageViewModel;
  const InsightsScreenCalories({super.key, required this.homePageViewModel});

  @override
  State<InsightsScreenCalories> createState() => _InsightsScreenCaloriesState();
}

class _InsightsScreenCaloriesState extends State<InsightsScreenCalories> {
  late CaloriesUseCase caloriesUseCase;

  @override
  void initState() {
    super.initState();

    caloriesUseCase = context.read<CaloriesUseCase>();
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
      children: [Text('Calories Insights')],
    );
  }
}
