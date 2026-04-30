import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/base_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/line_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/simple_box.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/list_utilities.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Heart Rate Insights',
          style: DefaultTextStyles.defaultTextStyleAppBar,
        ),
      ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildMinMaxHeartRateBar(colourScheme, viewModel),
          const SizedBox(height: 8),
          _heartRateLineChart(colourScheme, viewModel),
          const SizedBox(height: 8),
          _heartRateVariabilities(colourScheme, viewModel),
        ],
      ),
    );
  }

  Widget _heartRateLineChart(
    ColorScheme colourScheme,
    HomePageViewModel viewModel,
  ) {
    final data = viewModel.allHeartRatePast24Hr
      ..sort((a, b) => a.time.isAfter(b.time) ? 1 : -1);

    final sampledData = ListUtilities.takeEvenSpreadSample(data, 50);

    final formattedData = sampledData
        .map(
          (e) => ({'date': e.time.millisecondsSinceEpoch, 'value': e.median}),
        )
        .toList();

    return Column(
      children: [
        Text(
          'Median Heart Rate over the last 24 hours',
          style: DefaultTextStyles.defaultTextStyleBold,
        ),
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
    );
  }

  Widget _heartRateVariabilities(
    ColorScheme colourScheme,
    HomePageViewModel viewModel,
  ) {
    final data = viewModel.hrv;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Heart Rate Variabilities',
          style: DefaultTextStyles.defaultTextStyleTitleBold,
        ),
        const SizedBox(height: 8),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 16,
            crossAxisSpacing: 8,
            mainAxisExtent: 100,
          ),
          children: [
            _buildHRVDescriptor(
              colourScheme: colourScheme,
              hrvType: 'RMSSD',
              hrv: data.rmssd,
              hrvUnits: 'ms',
              hrvDescription:
                  'The root mean square of the differences between consecutive heart rates. A lower value indicates a more stable heart rate.',
            ),
            _buildHRVDescriptor(
              colourScheme: colourScheme,
              hrvType: 'SDNN',
              hrv: data.sdnn,
              hrvUnits: 'ms',
              hrvDescription:
                  'SDNN is a measure of HRV that calculates the average value of HRV in milliseconds and shows how far your HRV is from that average at any point in the day.',
            ),
            _buildHRVDescriptor(
              colourScheme: colourScheme,
              hrvType: 'PNN50',
              hrv: data.pnn50,
              hrvUnits: 'ms',
              hrvDescription:
                  'pNN50 shows how active your parasympathetic system is relative to the sympathetic nervous system. The higher the value, the more relaxed the body is. If the pNN50 is low, you’re either tired or over-stressed.',
            ),
            _buildHRVDescriptor(
              colourScheme: colourScheme,
              hrvType: 'NN50',
              hrv: data.nn50,
              hrvUnits: 'ms',
              hrvDescription:
                  'NN50 is a time-domain measure of Heart Rate Variability (HRV) representing the total number of pairs of adjacent normal-to-normal (NN) intervals that differ by more than 50 milliseconds. It is a key indicator of parasympathetic nervous system activity, with higher counts generally suggesting better heart health and recovery.',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHRVDescriptor({
    required ColorScheme colourScheme,
    required String hrvType,
    required num hrv,
    String hrvUnits = 'ms',
    String hrvDescription = '',
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: colourScheme.primary,
            title: Text(
              hrvType,
              style: DefaultTextStyles.defaultTextStyleTitleBold,
            ),
            content: Text(
              hrvDescription,
              style: DefaultTextStyles.defaultTextStyle,
            ),
            actions: [
              TextButton(
                style: DefaultButtonStyles.normalRed,
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
      child: SimpleBox(
        colourScheme: colourScheme,
        title: hrvType,
        value: hrv.toStringAsFixed(2),
        units: hrvUnits,
      ),
    );
  }

  Widget _buildMinMaxHeartRateBar(
    ColorScheme colourScheme,
    HomePageViewModel viewModel,
  ) {
    final maxHeartRate = viewModel.maxHeartRatePast24Hr;
    final currentHeartRate = viewModel.currentHeartRate.value;
    final minHeartRate = viewModel.allHeartRatePast24Hr
        .reduce((prev, curr) => curr.minimum < prev.minimum ? curr : prev)
        .minimum;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colourScheme.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                'Max Heart Rate (24 hr)',
                style: DefaultTextStyles.defaultTextStyleBold,
              ),
              const SizedBox(width: 8),
              Text(
                '${maxHeartRate.toStringAsFixed(2)} bpm',
                style: DefaultTextStyles.defaultTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Current Heart Rate',
                style: DefaultTextStyles.defaultTextStyleBold,
              ),
              const SizedBox(width: 8),
              Text(
                '${currentHeartRate.toStringAsFixed(2)} bpm',
                style: DefaultTextStyles.defaultTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Min Heart Rate (24 hr)',
                style: DefaultTextStyles.defaultTextStyleBold,
              ),
              const SizedBox(width: 8),
              Text(
                '${minHeartRate.toStringAsFixed(2)} bpm',
                style: DefaultTextStyles.defaultTextStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
