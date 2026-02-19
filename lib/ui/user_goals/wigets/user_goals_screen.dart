import 'package:elaros_mobile_app/config/constants/constants.dart';
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
    await viewModel.getUserGoals(isInitialLoad: false);
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
            const SizedBox(height: 20),

            const Text('Goals List'),

            const SizedBox(height: 8),

            SizedBox(
              height: 300,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: viewModel.userGoals.length,
                itemBuilder: (context, index) {
                  return _buildGoalListItem(viewModel, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalListItem(UserGoalsViewModel viewModel, int index) {
    final goal = viewModel.userGoals[index];

    int percentCompleted =
        ((goal.currentValue - goal.goalValue) * 100) ~/ goal.goalValue;

    if (percentCompleted < 0) {
      percentCompleted = 0;
    }
    if (percentCompleted > 100) {
      percentCompleted = 100;
    }

    Color iconColour = Colors.red;

    if (percentCompleted >= 50) {
      iconColour = Colors.yellow;
    }

    if (percentCompleted >= 100) {
      iconColour = Colors.green;
    }

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
            width: 150,
            child: Text('Goal: ${goal.goalName}', style: textStyle),
          ),

          const SizedBox(width: 8),
          // SizedBox(width: 100, child: Text(goal.dataSource, style: textStyle)),
          // const SizedBox(height: 20),
          SizedBox(
            width: 120,
            child: Text(
              'Target: ${goal.goalValue.toString()} | Current: ${goal.currentValue.toString()}',
              style: textStyle,
            ),
          ),

          SizedBox(width: 8),

          SizedBox(width: 30, child: Icon(Icons.circle, color: iconColour)),

          Column(
            children: [
              IconButton(
                onPressed: () {
                  viewModel.deleteUserGoal(goal);
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
