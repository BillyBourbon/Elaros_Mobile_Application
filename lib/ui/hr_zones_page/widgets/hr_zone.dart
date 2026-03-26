import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/view_models/hr_zone_view_model.dart';
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
    await viewModel.loadHrZoneData(isInitialLoad: true);
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
  required String percentage,
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
              percentage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
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
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
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
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(HrZoneViewModel viewModel) {
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),


   _buildZoneRow(
  'Recovery (50-60%)',
  0.45,
  color: const Color(0xFF4CAF50),
  title: 'Zone 1',
  percentage: '50% to 60% of max heart rate',
  description:
      'Low to moderate intensity. You can easily hold a conversation. You’re typically in this zone while warming up and cooling down, or during a relatively easy workout. It’s ideal for a recovery workout too.',
bpmText:
      'Your heart rate in this zone: ${viewModel.zone1Min}-${viewModel.zone1Max} bpm',
),

_buildZoneRow(
  'Sustainable (60-70%)',
  0.55,
  color: const Color(0xFF2196F3),
  title: 'Zone 2',
  percentage: '60% to 70% of max heart rate',
  description:
      'Moderate intensity. A light conversation is possible, though you might need to stop here and there to catch your breath. This zone is good for longer cardio activities to build endurance and for lighter workouts with lower injury risk.',
bpmText:
      'Your heart rate in this zone: ${viewModel.zone2Min}-${viewModel.zone2Max} bpm',
),

_buildZoneRow(
  'Caution (70-80%)',
  0.38,
  color: const Color(0xFFFFC107),
  title: 'Zone 3',
  percentage: '70% to 80% of max heart rate',
  description:
      'Moderate to high intensity. Chatter will be at a minimum as your breathing intensifies. A workout in this zone is comfortably hard and is good for building strength and endurance.',
bpmText:
      'Your heart rate in this zone: ${viewModel.zone3Min}-${viewModel.zone3Max} bpm',
),

_buildZoneRow(
  'Risk (80-90%)',
  0.22,
  color: const Color(0xFFE91E63),
  title: 'Zone 4',
  percentage: '80% to 90% of max heart rate',
  description:
      'High intensity. Talking takes effort. You’re pushing hard and approaching a redline effort to boost speed and strength. Workouts in this zone should usually be limited to one or two times a week.',
bpmText:
      'Your heart rate in this zone: ${viewModel.zone4Min}-${viewModel.zone4Max} bpm',
),

_buildZoneRow(
  'Max Effort (90-100%)',
  0.18,
  color: const Color(0xFFF44336),
  title: 'Zone 5',
  percentage: '90% to 100% of max heart rate',
  description:
      'Very high intensity. You’re trying to breathe, not talk. This is a max effort activity. These exercises strengthen your heart by forcing it to work at peak capacity while also building fast-twitch muscle fibres.',
bpmText:
      'Your heart rate in this zone: ${viewModel.zone5Min}-${viewModel.zone5Max} bpm',
),
        ],
      ),
    );
  }

Widget _buildZoneRow(
  String label,
  double fill, {
  required Color color,
  required String title,
  required String percentage,
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
          percentage: percentage,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: fill,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFD9D9D9),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 120),
              child: Text(
                bpmText,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  }     
