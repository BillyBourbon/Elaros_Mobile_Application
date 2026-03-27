import 'package:elaros_mobile_app/domain/use_cases/heart_rate_use_case.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreenHeartRateVariability extends StatefulWidget {
  final HomePageViewModel homePageViewModel;
  const InsightsScreenHeartRateVariability({super.key, required this.homePageViewModel});

  @override
  State<InsightsScreenHeartRateVariability> createState() =>
      _InsightsScreenHeartRateVariabilityState();
}

class _InsightsScreenHeartRateVariabilityState extends State<InsightsScreenHeartRateVariability> {
  late HeartRateUseCase heartRateUseCase;

  @override
  void initState() {
    super.initState();

    heartRateUseCase = context.read<HeartRateUseCase>();
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
      children: [Text('Heart Rate')],
    );
  }
}
