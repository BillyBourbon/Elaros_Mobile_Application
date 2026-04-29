import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:elaros_mobile_app/ui/common/widgets/input_elements/dropdown/dropdown_input.dart';
import 'package:elaros_mobile_app/ui/common/widgets/input_elements/text/text_input.dart';
import 'package:elaros_mobile_app/ui/common/widgets/snack_bars/error_snack_bar.dart';
import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
import 'package:elaros_mobile_app/utils/helpers/text_utilities.dart';
import 'package:flutter/material.dart';

class AddGoalOverlay extends StatefulWidget {
  final UserGoalsViewModel viewModel;

  const AddGoalOverlay({super.key, required this.viewModel});

  @override
  State<AddGoalOverlay> createState() => _AddGoalOverlayState();
}

class _AddGoalOverlayState extends State<AddGoalOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _goalNameController = TextEditingController();
  final _goalValueController = TextEditingController();
  String _goalType = '';
  bool snackbarOpen = false;

  @override
  void dispose() {
    _goalNameController.dispose();
    _goalValueController.dispose();
    super.dispose();
  }

  void _submitGoal() {
    if (_formKey.currentState!.validate()) {
      try {
        final goalName = _goalNameController.text.trim();
        if (goalName.isEmpty) {
          throw Exception('Please enter a valid goal name');
        }

        final goalValue = int.tryParse(_goalValueController.text.trim());
        if (goalValue == null) {
          throw Exception('Please enter a valid goal number');
        }

        if (goalValue <= 0) {
          throw Exception('Please enter a positive goal number');
        }

        widget.viewModel.addGoal(
          goalName: _goalNameController.text,
          dataSource: _goalType,
          goalValue: int.parse(_goalValueController.text),
        );
        widget.viewModel.getUserGoals(isInitialLoad: false);
        Navigator.of(context).pop();
      } catch (e) {
        if (snackbarOpen == false) {
          snackbarOpen = true;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(buildErrorSnackBarFromMessage(e.toString()));
          snackbarOpen = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserInputText(
                title: 'Goal Name',
                hintText: 'e.g., Daily Steps',
                controller: _goalNameController,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid goal name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              UserInputDropdown(
                title: 'Goal Type',
                hintText: '',
                options: existingGoalDataSources
                    .map((e) => TextUtilities.splitCamelCase(e))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _goalType = value
                        .toString()
                        .split(' ')
                        .map((e) => TextUtilities.capitalize(e.trim()))
                        .join('');
                  });
                },
              ),
              const SizedBox(height: 16),

              UserInputText(
                title: 'Goal Value',
                hintText: 'e.g., 10000',
                controller: _goalValueController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal value';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.viewModel.closeAddGoalOverlay();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submitGoal, child: const Text('Add Goal')),
      ],
    );
  }
}
