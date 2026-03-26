import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color fillColor;
  final double height;

  const ProgressBar({
    super.key,
    required this.value,
    this.backgroundColor = Colors.grey,
    this.fillColor = Colors.green,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            Container(
              height: height,
              width: constraints.maxWidth * value,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
