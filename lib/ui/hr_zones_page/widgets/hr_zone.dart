import 'package:elaros_mobile_app/ui/common/widgets/progress_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/view_models/hr_zone_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/heart_rate_zone_calculator.dart';
import 'package:elaros_mobile_app/utils/helpers/text_utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HrZoneScreen extends StatefulWidget {
  const HrZoneScreen({super.key});

  @override
  State<HrZoneScreen> createState() => _HrZoneScreenState();
}

class _HrZoneScreenState extends State<HrZoneScreen> {
  late HrZoneViewModel viewModel;

  final double contentWidth = 350;

  void _loadData() async {
    await viewModel.getHRZoneRanges();
  }

  @override
  void initState() {
    super.initState();
    viewModel = context.read<HrZoneViewModel>();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3ECE7),
      body: SafeArea(
        child: Consumer<HrZoneViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isError) {
              final snackBar = buildErrorSnackBar(viewModel);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }
            if (viewModel.message.isNotEmpty) {
              final snackBar = buildSuccessSnackBar(viewModel);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }

            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return _buildBody(viewModel);
          },
        ),
      ),
    );
  }

  void _showZoneInfo({
    required String title,
    required num min,
    required num max,
    required String description,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${min.toString()}bpm - ${max.toString()}bpm',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(HrZoneViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildStatCard(
                title: 'Max Heart Rate',
                value: '${viewModel.maxHeartRate.toInt()} bpm',
                highlighted: true,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                title: 'Resting Heart Rate',
                value: '${viewModel.restingHeartRate.toInt()} bpm',
              ),
              const SizedBox(height: 16),
              _buildZoneCard(viewModel),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const Center(
      child: Text(
        'Heart Rate Zones',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    bool highlighted = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE2D6B7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(HrZoneViewModel viewModel) {
    final zoneRanges = viewModel.hrZoneRanges;

    final zoneColourScale = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFFC107),
      const Color(0xFFE91E63),
      const Color(0xFFF44336),
    ];

    String bpmMessage(HeartRateZone zone) =>
        'Your heart rate in this zone between ${zone.min}bpm and ${zone.max == double.infinity ? viewModel.maxHeartRate : zone.max}bpm';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE2D6B7),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Heart Rate Zones',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),

          ...zoneRanges.map((zone) {
            final zoneI = zoneRanges.indexOf(zone);

            final color = zoneI > -1
                ? zoneI > zoneColourScale.length - 1
                      ? zoneColourScale.last
                      : zoneColourScale[zoneI]
                : zoneColourScale[0];

            return _buildZoneRow(
              label: TextUtilities.capitalize(zone.name),
              title: TextUtilities.capitalize(zone.name),
              color: color,
              min: zone.min,
              max: zone.max == double.infinity
                  ? viewModel.maxHeartRate
                  : zone.max.toInt(),
              description: zone.description,
              bpmText: bpmMessage(zone),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildZoneRow({
    required String label,
    required Color color,
    required String title,
    required double min,
    required num max,
    required String description,
    required String bpmText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _showZoneInfo(
            title: title,
            min: min,
            max: max,
            description: description,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ProgressBar(
                      height: 10,
                      value:
                          (min == 0 ? max * 0.8 : min) / viewModel.maxHeartRate,
                      currentValue: max.toDouble(),
                      backgroundColor: Colors.grey.shade300,
                      segment2Color: Colors.grey.shade300,
                      segment1Color: color,
                    ),
                  ),
                  // Expanded(
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: LinearProgressIndicator(
                  //       value: fill,
                  //       minHeight: 7,
                  //       backgroundColor: const Color(0xFFD9D9D9),
                  //       valueColor: AlwaysStoppedAnimation<Color>(color),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Text(
                  bpmText,
                  style: const TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
