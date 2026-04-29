import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/base_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/line_chart.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/date_utilities.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Rate Insights')),
      body: Consumer<HomePageViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }

  Widget _buildBody(HomePageViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Heart Rate Insights'),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: LineChart(
              data: viewModel.allHeartRatePast24Hr
                  .map((e) => ({'date': e.time, 'value': e.median}))
                  .toList(),
              mappingKeyX: 'date',
              mappingKeyY: 'value',
              xScaleType: ScaleType.ordinal,
              labelXMap: (e) => DateUtilities.getTimeString(
                DateTime.fromMillisecondsSinceEpoch(e.toInt()),
              ),
              xAxisTitle: 'Time',
              yAxisTitle: 'Heart Rate',
            ),
          ),
        ],
      ),
    );
  }
}
