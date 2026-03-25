import 'package:elaros_mobile_app/ui/user_goals/view_models/user_goals_view_model.dart';
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
  final _dataSourceController = TextEditingController();
  final _goalValueController = TextEditingController();

  @override
  void dispose() {
    _goalNameController.dispose();
    _dataSourceController.dispose();
    _goalValueController.dispose();
    super.dispose();
  }

  void _submitGoal() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.addGoal(
        goalName: _goalNameController.text,
        dataSource: _dataSourceController.text,
        goalValue: int.parse(_goalValueController.text),
      );

      widget.viewModel.getUserGoals(isInitialLoad: false);

      Navigator.of(context).pop();
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
              TextFormField(
                controller: _goalNameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., Daily Steps',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataSourceController,
                decoration: const InputDecoration(
                  labelText: 'Data Source',
                  hintText:
                      'e.g., StepCount', // names listed in constants so should make this a dropdown
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a data source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalValueController,
                decoration: const InputDecoration(
                  labelText: 'Goal Value',
                  hintText: 'e.g., 10000',
                ),
                keyboardType: TextInputType.number,
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
