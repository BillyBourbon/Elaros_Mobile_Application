import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String mappingKeyX;
  final String mappingKeyY;
  final String mappingKeyColour;
  final BarStyle barStyle;
  final bool darkTheme;
  final LegendPosition legendPosition;

  /// [data] is a list of maps, where each map represents a row in the table.
  /// [mappingKeyX] is the key of the row that will be used as the x-axis.
  /// [mappingKeyY] is the key of the row that will be used as the y-axis.
  /// [mappingKeyColour] is the key of the row that will be used to assign the colour.
  /// [barStyle] is the style of the bars.
  /// [darkTheme] is a boolean that determines whether the chart will use the
  /// dark theme or not.
  /// [legendPosition] is the position of the legend.
  const BarChart({
    super.key,
    required this.data,
    required this.mappingKeyX,
    required this.mappingKeyY,
    required this.mappingKeyColour,
    this.barStyle = BarStyle.grouped,
    this.darkTheme = true,
    this.legendPosition = LegendPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return CristalyseChart()
        .data(data)
        .mapping(x: mappingKeyX, y: mappingKeyY, color: mappingKeyColour)
        .geomBar(width: 0.4, alpha: 0.7, style: barStyle)
        .scaleXOrdinal()
        .scaleYContinuous(min: 0)
        .theme(
          darkTheme
              ? ChartTheme.solarizedDarkTheme()
              : ChartTheme.solarizedLightTheme(),
        )
        .legend(position: legendPosition)
        .build();
  }
}
