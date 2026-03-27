import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/line_chart.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InsightsScreenHeartRate extends StatefulWidget {
  final HomePageViewModel homePageViewModel;
  const InsightsScreenHeartRate({super.key, required this.homePageViewModel});

  @override
  State<InsightsScreenHeartRate> createState() =>
      _InsightsScreenHeartRateState();
}

class _InsightsScreenHeartRateState extends State<InsightsScreenHeartRate> {
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
      children: [
        Text('Heart Rate'),
        SizedBox(height: 8),

        LineChart(
          data: viewModel.allHeartRatePast24Hr
              .map((e) => {"value": e.value.toInt(), "date": e.date})
              .toList(),
          mappingKeyX: 'date',
          mappingKeyY: 'value',
        ),
      ],
    );
  }
}
