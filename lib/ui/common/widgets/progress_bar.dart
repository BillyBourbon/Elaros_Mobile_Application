import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value; // segment 1 end (0..1)
  final double? currentValue; // segment 2 end (0..1)
  final Color backgroundColor;
  final Color segment1Color;
  final Color segment2Color;
  final double height;

  const ProgressBar({
    super.key,
    required this.value,
    this.currentValue,
    this.backgroundColor = Colors.grey,
    this.segment1Color = Colors.green,
    this.segment2Color = Colors.orange,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final seg1 = value.clamp(0.0, 1.0);
        final seg2 = currentValue?.clamp(seg1, 1.0);

        final seg1Width = width * seg1;
        final seg2Width = seg2 != null ? width * (seg2 - seg1) : 0.0;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Row(
            children: [
              Container(
                width: seg1Width,
                height: height,
                decoration: BoxDecoration(
                  color: segment1Color,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(height / 2),
                    right: seg2 == null
                        ? Radius.circular(height / 2)
                        : Radius.zero,
                  ),
                ),
              ),
              if (seg2Width > 0)
                Container(
                  width: seg2Width,
                  height: height,
                  decoration: BoxDecoration(
                    color: segment2Color,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(height / 2),
                    ),
                  ),
                ),
              if (width - seg1Width - seg2Width > 0)
                Expanded(child: SizedBox()),
            ],
          ),
        );
      },
    );
  }
}
