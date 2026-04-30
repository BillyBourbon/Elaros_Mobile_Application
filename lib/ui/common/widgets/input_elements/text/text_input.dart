import 'package:flutter/material.dart';

class UserInputText extends StatefulWidget {
  final String title;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const UserInputText({
    super.key,
    required this.title,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.validator,
  });

  @override
  State<UserInputText> createState() => _UserInputTextState();
}

class _UserInputTextState extends State<UserInputText> {
  late final TextEditingController _controller;
  late final bool _isExternalController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isExternalController = widget.controller != null;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validate(String value) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Input field
        SizedBox(
          width: double.infinity,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
              _validate(value);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: _errorText,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.dividerColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.secondary,
                  width: 1.5,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.error),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colorScheme.error, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
