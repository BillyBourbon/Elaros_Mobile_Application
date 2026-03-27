import 'package:flutter/material.dart';

class DropdownMultiSelect extends StatefulWidget {
  final List<String> options;
  final List<String> selected;

  const DropdownMultiSelect({
    super.key,
    required this.options,
    required this.selected,
  });

  @override
  State<DropdownMultiSelect> createState() => _DropdownMultiSelectState();
}

class _DropdownMultiSelectState extends State<DropdownMultiSelect> {
  late List<String> tempSelected;

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select options'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.options.map((option) {
            final isSelected = tempSelected.contains(option);

            return CheckboxListTile(
              value: isSelected,
              title: Text(option),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    tempSelected.add(option);
                  } else {
                    tempSelected.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, tempSelected),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
