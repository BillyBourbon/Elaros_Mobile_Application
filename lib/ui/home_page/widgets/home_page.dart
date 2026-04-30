import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/ui/common/widgets/progress_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/simple_box.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_calories.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_heart_rate.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/insights/insights_steps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        titleTextStyle: DefaultTextStyles.defaultTextStyleAppBar,
      ),
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
        final energyScore = viewModel.energyScore;

        String? energyScoreText;
        Color scoreColor = DefaultColors.red;
        if (energyScore > 0 && energyScore < 25) {
          scoreColor = DefaultColors.red;
          energyScoreText = 'Very Low';
        }
        if (energyScore >= 25 && energyScore < 50) {
          scoreColor = DefaultColors.orange;
          energyScoreText = 'Low';
        }
        if (energyScore >= 50 && energyScore < 75) {
          scoreColor = DefaultColors.yellow;
          energyScoreText = 'Moderate';
        }
        if (energyScore >= 75) {
          scoreColor = DefaultColors.green;
          energyScoreText = 'High';
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
                  'Energy Score',
                  style: DefaultTextStyles.defaultTextStyleTitleBold,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                viewModel.energyScore.toStringAsFixed(2),
                style: DefaultTextStyles.defaultTextStyleBold,
              ),
              Text('/100', style: DefaultTextStyles.defaultTextStyleLight),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: scoreColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scoreColor.withAlpha(200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      energyScoreText ?? 'Unknown',
                      style: DefaultTextStyles.defaultTextStyle,
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
              Text(
                'Daily Metrics',
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
                  _buildDailyMetricWidget(
                    title: 'Heart Rate',
                    value: (viewModel.currentHeartRate.value).toStringAsFixed(
                      2,
                    ),
                    units:
                        'bpm (max ${viewModel.maxHeartRatePast24Hr.toStringAsFixed(0)})',
                    insightPage: () =>
                        InsightsScreenHeartRate(homePageViewModel: viewModel),
                    // TestPage(),
                  ),

                  _buildDailyMetricWidget(
                    title: 'HRV',
                    value: (viewModel.hrv.rmssd).toStringAsFixed(2),
                    units: 'ms (RMSSD)',
                    insightPage: () =>
                        InsightsScreenHeartRate(homePageViewModel: viewModel),
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
        child: SimpleBox(
          colourScheme: colourScheme,
          title: title,
          value: value,
          units: units,
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

          final Map<int, Color> colorMap = DefaultColors.hrZoneColourScale;

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

              final isActive = hrPosition > zoneStart && hrPosition < zoneEnd;

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
                  style: DefaultTextStyles.defaultTextStyleTitleBold,
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
            child: Text(
              'Exertion Warnings',
              style: DefaultTextStyles.defaultTextStyleTitleBold,
            ),
          ),
        ],
      ),
    );
  }
}
