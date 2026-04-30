import 'package:elaros_mobile_app/config/constants/constants.dart';
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
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colourScheme.primary,
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
        final theme = Theme.of(context);
        final colourScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: colourScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: DefaultTextStyles.defaultTextStyleTitleBold),
                const SizedBox(height: 8),
                Text(
                  '${min.toString()}bpm - ${max.toString()}bpm',
                  style: DefaultTextStyles.defaultTextStyleLight,
                ),
                const SizedBox(height: 14),
                Text(description, style: DefaultTextStyles.defaultTextStyle),
                const SizedBox(height: 20),
              ],
            ),
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
                context: context,
                title: 'Max Heart Rate',
                value: '${viewModel.maxHeartRate.toInt()} bpm',
                highlighted: true,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                context: context,
                title: 'Resting Heart Rate',
                value: '${viewModel.restingHeartRate.toInt()} bpm',
              ),
              const SizedBox(height: 16),
              _buildZoneCard(viewModel: viewModel, context: context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Center(
      child: Text(
        'Heart Rate Zones',
        style: DefaultTextStyles.defaultTextStyleTitleBold,
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required BuildContext context,
    bool highlighted = false,
  }) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colourScheme.secondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DefaultTextStyles.defaultTextStyleTitleBold),
          const SizedBox(height: 2),
          Text(value, style: DefaultTextStyles.defaultTextStyleBold),
        ],
      ),
    );
  }

  Widget _buildZoneCard({
    required HrZoneViewModel viewModel,
    required BuildContext context,
  }) {
    final zoneRanges = viewModel.hrZoneRanges;

    final zoneColourScale = DefaultColors.hrZoneColourScale.values.toList();

    String bpmMessage(HeartRateZone zone) =>
        'Your heart rate in this zone between ${zone.min}bpm and ${zone.max == double.infinity ? viewModel.maxHeartRate : zone.max}bpm';

    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colourScheme.secondary,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heart Rate Zones',
            style: DefaultTextStyles.defaultTextStyleTitleBold,
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
                      style: DefaultTextStyles.defaultTextStyleLight,
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
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Text(
                  bpmText,
                  style: DefaultTextStyles.defaultTextStyleLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
