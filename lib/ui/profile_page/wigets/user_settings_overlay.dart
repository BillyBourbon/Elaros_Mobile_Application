import 'package:elaros_mobile_app/ui/common/widgets/input_elements/text_input.dart';
import 'package:elaros_mobile_app/ui/profile_page/view_model/profile_page_view_model.dart';
import 'package:flutter/material.dart';

class UserSettingsOverlay extends StatefulWidget {
  final ProfilePageViewModel viewModel;

  const UserSettingsOverlay({super.key, required this.viewModel});

  @override
  State<UserSettingsOverlay> createState() => _UserSettingsOverlayState();
}

class _UserSettingsOverlayState extends State<UserSettingsOverlay> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: widget.viewModel.userProfile.toMap().keys.length,
          itemBuilder: (context, index) {
            return _buildProfileListItem(widget.viewModel, index);
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.viewModel.closeSettingsOverlay();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.viewModel.saveUserProfile();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildProfileListItem(ProfilePageViewModel viewModel, int index) {
    final map = viewModel.userProfile.toMap();
    final key = map.keys.toList()[index];
    final value = map[key]?.toString() ?? '';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final title = key
        .split('_')
        .map((e) => '${e[0].toUpperCase()}${e.substring(1)}')
        .join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: UserInputText(
        title: title,
        hintText: value,
        onChanged: (newValue) {
          try {
            viewModel.updateField(key, newValue);
          } catch (e) {
            //
          }
        },
      ),
    );
  }
}
