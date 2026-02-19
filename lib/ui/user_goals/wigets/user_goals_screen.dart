import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserGoalsScreen extends StatefulWidget {
  const UserGoalsScreen({super.key});

  @override
  State<UserGoalsScreen> createState() => _UserGoalsScreenState();
}

class _UserGoalsScreenState extends State<UserGoalsScreen> {
  late UserGoalsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = context.read<UserGoalsViewModel>();

    _getUserGoalsData();
  }

  void _getUserGoalsData() async {
    await viewModel.getUserGoals(isInitialLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserGoalsViewModel>(
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

  Widget _buildBody(UserGoalsViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text('User Goals'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: viewModel.userGoals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(viewModel.userGoals[index].goalName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
