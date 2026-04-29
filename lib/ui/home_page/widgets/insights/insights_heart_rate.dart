import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/base_chart.dart';
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
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colourScheme.primary,
      appBar: AppBar(title: const Text('Heart Rate Insights')),
      body: Consumer<HomePageViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel, context);
        },
      ),
    );
  }

  Widget _buildBody(HomePageViewModel viewModel, BuildContext context) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    final data = viewModel.allHeartRatePast24Hr
      ..sort((a, b) => a.time.isAfter(b.time) ? 1 : -1);

    final sampledData = data;

    final formattedData = data
        .map(
          (e) => ({'date': e.time.millisecondsSinceEpoch, 'value': e.median}),
        )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: LineChart(
              colorScheme: colourScheme,
              data: formattedData,
              mappingKeyX: 'date',
              mappingKeyY: 'value',
              xScaleType: ScaleType.continuous,
              labelXMap: (e) {
                final date = DateTime.fromMillisecondsSinceEpoch(e.toInt());
                final hour = date.hour;

                final hourText = hour > 12 ? '${hour - 12}PM' : '${hour}AM';
                return hourText;
              },
              xAxisTitle: 'Time',
              yAxisTitle: 'Heart Rate',
            ),
          ),
        ],
      ),
    );
  }
}
