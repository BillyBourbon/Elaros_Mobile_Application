import 'package:flutter/material.dart';

class SimpleBox extends StatelessWidget {
  final ColorScheme? colourScheme;
  final String title;
  final String value;
  final String units;

  const SimpleBox({
    super.key,
    required this.colourScheme,
    required this.title,
    this.value = '',
    this.units = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      // width: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colourScheme!.secondary,
        border: BoxBorder.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4),
              Text(
                units,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
