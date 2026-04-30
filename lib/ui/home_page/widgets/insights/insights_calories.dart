import 'package:elaros_mobile_app/config/constants/constants.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colourScheme.primary,
      appBar: AppBar(
        title: const Text('Step Count Insights'),
        centerTitle: true,
        titleTextStyle: DefaultTextStyles.defaultTextStyleAppBar,
      ),
      body: Consumer<HomePageViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel, colourScheme);
        },
      ),
    );
  }

  Widget _buildBody(HomePageViewModel viewModel, ColorScheme colourScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const SizedBox(height: 8)],
      ),
    );
  }
}
