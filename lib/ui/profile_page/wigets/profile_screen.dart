import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/profile_page/view_model/profile_page_view_model.dart';
import 'package:elaros_mobile_app/ui/profile_page/wigets/user_settings_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfilePageViewModel viewModel;

  ThemeData? theme;
  ColorScheme? colourScheme;

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
    theme = Theme.of(context);
    colourScheme = theme!.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => viewModel.openSettingsOverlay(),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<ProfilePageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isSettingsOverlayOpen) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => UserSettingsOverlay(viewModel: viewModel),
              );
            });
          }

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
          children: [_profileBanner(viewModel), const SizedBox(height: 20)],
        ),
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
            width: 350,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: colourScheme!.secondary,
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
