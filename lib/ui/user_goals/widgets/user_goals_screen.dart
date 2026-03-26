import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/success_snack_bar.dart';
import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
import 'package:elaros_mobile_app/ui/user_goals/widgets/add_goal_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserGoalsScreen extends StatefulWidget {
  const UserGoalsScreen({super.key});

  @override
  State<UserGoalsScreen> createState() => _UserGoalsScreenState();
}

class _UserGoalsScreenState extends State<UserGoalsScreen> {
  late UserGoalsViewModel viewModel;
  ThemeData? theme;
  ColorScheme? colourScheme;

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
    theme = Theme.of(context);
    colourScheme = theme!.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Goals'), centerTitle: true),
      body: DecoratedBox(
        decoration: BoxDecoration(color: colourScheme!.primary),
        child: Consumer<UserGoalsViewModel>(
          builder: (context, viewModel, child) {
            // Show add goal overlay when triggered
            if (viewModel.isAddGoalOverlayOpen) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AddGoalOverlay(viewModel: viewModel),
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
      ),
    );
  }

  Widget _buildBody(UserGoalsViewModel viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            const Text(
              'Set your goals and keep a track of your progress!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 400,
              child: ListView.separated(
                shrinkWrap: false,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: viewModel.userGoals.length,
                itemBuilder: (context, index) {
                  return _buildGoalListItem(viewModel, index);
                },
              ),
            ),

            const SizedBox(height: 20),

            FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                viewModel.openAddGoalOverlay();
              },
              child: const Icon(Icons.add),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalListItem(UserGoalsViewModel viewModel, int index) {
    final goal = viewModel.userGoals[index];

    int goalValue = goal.goalValue.toInt();
    int currentValue = goal.currentValue.toInt();

    double percentCompleted = (currentValue / goalValue) * 100;

    if (percentCompleted < 0) {
      percentCompleted = 0;
    }

    Color iconColour = Colors.red;

    if (percentCompleted >= 100) {
      iconColour = Colors.green;
    } else if (percentCompleted >= 50) {
      iconColour = Colors.yellow;
    } else if (percentCompleted >= 25) {
      iconColour = Colors.orange;
    } else {
      iconColour = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: colourScheme!.secondary,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              'Goal: ${goal.goalName} (${percentCompleted.toStringAsFixed(0)}%)',
              style: textStyle,
            ),
          ),

          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(
              'Target: ${goalValue.toString()} | Current: ${currentValue.toString()}',
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
