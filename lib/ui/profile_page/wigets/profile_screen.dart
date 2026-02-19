import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/profile_page/view_model/profile_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfilePageViewModel viewModel;

  var textStyle = TextStyle(
    color: Colors.grey.shade600,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  double contentWidth = 350;

  void _getProfileData() async {
    await viewModel.getUserProfile(isInitialLoad: true);
  }

  @override
  void initState() {
    super.initState();

    viewModel = context.read<ProfilePageViewModel>();

    _getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfilePageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isError) {
            SnackBar snackBar = buildErrorSnackBar(viewModel);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }
          if (viewModel.message.isNotEmpty) {
            SnackBar snackBar = buildSuccessSnackBar(viewModel);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }

          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildBody(viewModel);
          }
        },
      ),
    );
  }

  Widget _buildBody(ProfilePageViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _profileBanner(viewModel),

            const SizedBox(height: 20),

            _profileContainer(viewModel),

            const SizedBox(height: 20),

            saveSettingsButton(viewModel),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget saveSettingsButton(ProfilePageViewModel viewModel) {
    return ElevatedButton(
      onPressed: () => viewModel.saveUserProfile(),
      child: const Text('Save Settings'),
    );
  }

  Widget _profileContainer(ProfilePageViewModel viewModel) {
    return Center(
      child: SizedBox(
        width: contentWidth,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: viewModel.userProfile.toMap().keys.length,
          itemBuilder: (context, index) {
            return _buildProfileListItem(viewModel, index);
          },
        ),
      ),
    );
  }

  Widget _buildProfileListItem(ProfilePageViewModel viewModel, int index) {
    final map = viewModel.userProfile.toMap();
    final key = map.keys.toList()[index];
    final value = map[key]?.toString() ?? '';

    final controller = TextEditingController(text: value);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              key
                  .split('_')
                  .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
                  .join(' '),
              style: textStyle,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
              ),
              style: textStyle,
              onChanged: (newValue) {
                String oldValue = controller.text;
                try {
                  viewModel.updateField(key, newValue);
                } catch (e) {
                  controller.text = oldValue;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileBanner(ProfilePageViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            width: contentWidth,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hello ${viewModel.userProfile.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
