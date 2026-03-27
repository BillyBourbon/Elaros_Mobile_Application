import 'package:elaros_mobile_app/ui/common/widgets/progress_bar.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_calories.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_hrv.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_steps.dart';
import 'package:elaros_mobile_app/ui/test_page/wigets/test_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageViewModel homePageViewModel;

  ThemeData? theme;
  ColorScheme? colourScheme;

  @override
  void initState() {
    super.initState();

    homePageViewModel = context.read<HomePageViewModel>();

    homePageViewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    colourScheme = theme!.colorScheme;

    return Scaffold(
      appBar: AppBar(centerTitle: true),
      body: Container(
        alignment: Alignment.center,
        color: colourScheme!.primary,
        padding: EdgeInsets.all(8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const SizedBox(height: 8),
            _buildEnergyScore(),
            const SizedBox(height: 8),
            _buildDailyMetrics(),
            const SizedBox(height: 8),
            _buildHRZone(),
            const SizedBox(height: 8),
            _buildExertionWarnings(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyScore() {
    return Consumer<HomePageViewModel>(
      key: const Key('energyScore'),
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colourScheme!.secondary,
            border: BoxBorder.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Energy Score',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${viewModel.energyScore}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '/100',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade300,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '${'Moderate'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyMetrics() {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Metrics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  _buildDailyMetricWidget(
                    title: 'Heart Rate',
                    value: (viewModel.currentHeartRate.value).toStringAsFixed(
                      2,
                    ),
                    units:
                        'bpm (max ${viewModel.maxHeartRatePast24Hr.toStringAsFixed(0)})',
                    insightPage: () =>
                        // InsightsScreenHeartRate(homePageViewModel: viewModel),
                        TestPage(),
                  ),

                  _buildDailyMetricWidget(
                    title: 'HRV',
                    value: (viewModel.hrv.rmssd).toStringAsFixed(2),
                    units: 'ms (RMSSD)',
                    insightPage: () => InsightsScreenHeartRateVariability(
                      homePageViewModel: viewModel,
                    ),
                  ),

                  _buildDailyMetricWidget(
                    title: 'Steps',
                    value: (viewModel.totalDailySteps).toStringAsFixed(0),
                    insightPage: () =>
                        InsightsScreenStepCount(homePageViewModel: viewModel),
                  ),

                  _buildDailyMetricWidget(
                    title: 'Calories',
                    value: (viewModel.totalCalories).toStringAsFixed(2),
                    units: 'kcal',
                    insightPage: () =>
                        InsightsScreenCalories(homePageViewModel: viewModel),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyMetricWidget({
    required String title,
    required String value,
    required Widget Function() insightPage,
    String units = '',
  }) {
    return Hero(
      tag: title,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => insightPage()),
          );
        },
        child: Container(
          height: 30,
          width: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colourScheme!.secondary,
            border: BoxBorder.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Text(
                    units,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHRZone() {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        Widget zoneList;

        if (viewModel.hrZoneRanges.isEmpty) {
          zoneList = const SizedBox();
        } else {
          final sorted = viewModel.hrZoneRanges.toList()
            ..sort((a, b) => a.max.compareTo(b.max));

          final Map<int, Color> colorMap = {
            0: Colors.blue.shade800,
            1: Colors.green.shade600,
            2: Colors.yellow.shade600,
            3: Colors.orange.shade600,
            4: Colors.red.shade600,
          };

          zoneList = ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final zone = sorted[index];

              final mainColor = index >= 0 && index < colorMap.length
                  ? colorMap[index]!
                  : colorMap[colorMap.length - 1]!;
              final secondaryColor = index >= 0 && index < colorMap.length - 1
                  ? colorMap[index + 1]!
                  : colorMap[colorMap.length - 1]!;

              final maxHr = viewModel.maxHeartRatePast24Hr;
              final hr = viewModel.currentHeartRate.value;

              final zoneEnd = zone.max / maxHr;
              final zoneStart = hr > zone.max ? zoneEnd : zone.min / maxHr;
              final hrPosition = hr / maxHr;

              final isActive = viewModel.currentHrZone.currentZone == zone.name;

              return _buildHRZoneWidget(
                name: zone.name,
                mainColor: mainColor,
                secondaryColor: secondaryColor,
                minValue: zoneStart,
                currentValue: isActive ? hrPosition : 0,
                isActive: isActive,
              );
            },
          );
        }

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colourScheme!.secondary,
            border: BoxBorder.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Heart Rate Zones',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),

              zoneList,
            ],
          ),
        );
      },
    );
  }

  Widget _buildHRZoneWidget({
    required String name,
    required Color mainColor,
    required Color secondaryColor,
    required double minValue,
    required double currentValue,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: isActive ? 18 : 16,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: ProgressBar(
              height: 10,
              value: minValue,
              segment1Color: mainColor,
              currentValue: currentValue,
              segment2Color: secondaryColor,
              backgroundColor: isActive ? Colors.black45 : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExertionWarnings() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colourScheme!.secondary,
        border: BoxBorder.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Exertion Warnings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class InsightsScreenSteps {
  const InsightsScreenSteps();
}
