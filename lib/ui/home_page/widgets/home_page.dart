import 'package:elaros_mobile_app/ui/common/widgets/progress_bar.dart';
import 'package:elaros_mobile_app/ui/home_page/view_model/home_page_view_model.dart';
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

    homePageViewModel.getLatestHeartRate();
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
            '${00}',
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMetrics() {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(8),
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
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                  mainAxisExtent: 100,
                ),
                children: [
                  _buildDailyMetricWidget(
                    title: 'Heart Rate',
                    value: (viewModel.heartRate.value).toString(),
                    units: 'bpm',
                  ),

                  _buildDailyMetricWidget(title: 'HRV', value: 0.toString()),

                  _buildDailyMetricWidget(
                    title: 'Steps',
                    value: (viewModel.stepCount.value).toString(),
                  ),

                  _buildDailyMetricWidget(
                    title: 'Calories',
                    value: (viewModel.calories.value).toString(),
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
    String units = '',
  }) {
    return Container(
      height: 30,
      width: 60,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
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
    );
  }

  Widget _buildHRZone() {
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
              'Heart Rate Zones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),

          _buildHRZoneWidget(
            name: 'Recovery',
            color: Colors.blue.shade600,
            value: 0.80,
          ),

          _buildHRZoneWidget(
            name: 'Sustainable',
            color: Colors.green.shade600,
            value: 0.60,
            isActive: true,
          ),

          _buildHRZoneWidget(
            name: 'Caution',
            color: Colors.amber.shade600,
            value: 0.40,
          ),

          _buildHRZoneWidget(
            name: 'Risk',
            color: Colors.red.shade600,
            value: 0.20,
          ),
        ],
      ),
    );
  }

  Widget _buildHRZoneWidget({
    required String name,
    required Color color,
    required double value,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              name,
              style: TextStyle(
                fontSize: isActive ? 18 : 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w200,
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: ProgressBar(
              value: value,
              height: 10,
              fillColor: color,
              backgroundColor: isActive ? Colors.black : Colors.grey.shade300,
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
