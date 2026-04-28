import 'package:clock/clock.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/bar_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/base_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/heat_map_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/simple_box.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/date_utilities.dart';
import 'package:elaros_mobile_app/utils/helpers/text_utilities.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Step Count Insights')),
      body: Consumer<HomePageViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel, colourScheme);
        },
      ),
    );
  }

  Widget _buildBody(HomePageViewModel viewModel, ColorScheme colourScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _insightsBar(colourScheme, viewModel),
          const SizedBox(height: 8),
          _todaysBarChart(viewModel),
          const SizedBox(height: 8),
          _thisMonthsHeatmap(viewModel),
        ],
      ),
    );
  }

  Column _thisMonthsHeatmap(HomePageViewModel viewModel) {
    final formattedDataHeatmap = viewModel.lastFourWeeksStepData
        .asMap()
        .entries
        .map(
          (e) => {
            'time': e.value.time,
            'weekday': TextUtilities.capitalize(
              DateUtilities.getWeekDayFromDateTime(
                e.value.time,
              ).substring(0, 3),
            ),
            'week':
                'Week ${((viewModel.lastFourWeeksStepData.length - 1 - e.key) ~/ 7) + 1}',
            'value': e.value.total,
          },
        )
        .toList();

    return Column(
      children: [
        Text('Your last 4 weeks of steps'),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: HeatMapChart(
            data: formattedDataHeatmap,
            mappingKeyX: 'weekday',
            mappingKeyY: 'week',
            mappingKeyColour: 'value',
          ),
        ),
      ],
    );
  }

  Column _todaysBarChart(HomePageViewModel viewModel) {
    final data = viewModel.todaysStepCountByHour!
      ..sort((a, b) => a.time.compareTo(b.time));

    final formattedDataBarChart = data
        .map((e) => {'hour': e.time.hour, 'value': e.total})
        .toList();

    return Column(
      children: [
        Text('Total steps per hour over the last 24 hours'),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: BarChart(
            data: formattedDataBarChart,
            mappingKeyX: 'hour',
            mappingKeyY: 'value',
            xAxisTitle: 'Hour',
            yAxisTitle: 'Steps',
            labelYMap: (e) => e.toInt().toString(),
            labelXMap: (e) => e > 12 ? '${e - 12}PM' : '${e}AM',
            xScaleType: ScaleType.ordinal,
            barWidth: 1,
          ),
        ),
      ],
    );
  }

  SingleChildScrollView _insightsBar(
    ColorScheme colourScheme,
    HomePageViewModel viewModel,
  ) {
    int averageTotalDailyStepsLastWeek =
        (viewModel.lastFourWeeksStepData
                    .where(
                      (e) => e.time.isAfter(
                        clock.now().subtract(const Duration(days: 7)),
                      ),
                    )
                    .fold(0, (prev, curr) => prev + curr.total.toInt()) /
                7)
            .floor();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SimpleBox(
            colourScheme: colourScheme,
            title: 'Total Steps Today',
            value: viewModel.totalDailySteps.toInt().toString(),
            units: 'steps',
          ),
          const SizedBox(width: 8),
          SimpleBox(
            colourScheme: colourScheme,
            title: 'Average Steps Past Week',
            value: averageTotalDailyStepsLastWeek.toString(),
            units: 'steps',
          ),
        ],
      ),
    );
  }
}
