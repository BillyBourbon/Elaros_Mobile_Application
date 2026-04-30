import 'package:elaros_mobile_app/ui/common/widgets/input_elements/dropdown/dropdown_multi_select.dart';
import 'package:flutter/material.dart';

class UserInputDropdown extends StatefulWidget {
  final String title;
  final String hintText;
  final List<String> options;

  final bool isMultiSelect;

  final ValueChanged<dynamic>? onChanged;
  final String? Function(dynamic)? validator;

  const UserInputDropdown({
    super.key,
    required this.title,
    required this.hintText,
    required this.options,
    this.isMultiSelect = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<UserInputDropdown> createState() => _UserInputDropdownState();
}

class _UserInputDropdownState extends State<UserInputDropdown> {
  String? _selectedValue;
  List<String> _selectedValues = [];
  String? _errorText;

  void _validate(dynamic value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget field;

    if (!widget.isMultiSelect) {
      field = DropdownButtonFormField<String>(
        initialValue: _selectedValue,
        dropdownColor: colorScheme.secondary,
        items: widget.options
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() => _selectedValue = value);
          widget.onChanged?.call(value);
          _validate(value);
        },
        decoration: _inputDecoration(theme, colorScheme),
      );
    } else {
      field = GestureDetector(
        onTap: () async {
          final result = await showDialog<List<String>>(
            context: context,
            builder: (_) => DropdownMultiSelect(
              options: widget.options,
              selected: _selectedValues,
            ),
          );

          if (result != null) {
            setState(() => _selectedValues = result);
            widget.onChanged?.call(result);
            _validate(result);
          }
        },
        child: InputDecorator(
          decoration: _inputDecoration(theme, colorScheme),
          child: Text(
            _selectedValues.isEmpty
                ? widget.hintText
                : _selectedValues.join(', '),
            style: TextStyle(
              color: _selectedValues.isEmpty
                  ? theme.hintColor
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(width: double.infinity, child: field),
      ],
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, ColorScheme colorScheme) {
    return InputDecoration(
      hintText: widget.hintText,
      errorText: _errorText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
    );
  }
}
