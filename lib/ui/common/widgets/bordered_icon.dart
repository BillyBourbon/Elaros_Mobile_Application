import 'package:flutter/material.dart';

class BorderedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const BorderedIcon({
    super.key,
    required this.icon,
    this.color = Colors.white,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(icon, color: Colors.black, size: size),
        Icon(icon, color: color, size: size - 2),
      ],
    );
  }
}
