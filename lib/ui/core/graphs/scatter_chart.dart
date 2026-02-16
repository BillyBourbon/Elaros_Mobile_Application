import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

class ScatterChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String mappingKeyX;
  final String mappingKeyY;
  final String mappingKeyColour;
  final PointShape pointShape;
  final bool darkTheme;
  final LegendPosition legendPosition;

  /// [data] is a list of maps, where each map represents a row in the table.
  /// [mappingKeyX] is the key of the row that will be used as the x-axis.
  /// [mappingKeyY] is the key of the row that will be used as the y-axis.
  /// [mappingKeyColour] is the key of the row that will be used to assign the colour.
  /// [pointShape] is the shape of the points.
  /// [darkTheme] is a boolean that determines whether the chart will use the
  /// dark theme or not.
  /// [legendPosition] is the position of the legend.
  const ScatterChart({
    super.key,
    required this.data,
    required this.mappingKeyX,
    required this.mappingKeyY,
    required this.mappingKeyColour,
    this.pointShape = PointShape.circle,
    this.darkTheme = true,
    this.legendPosition = LegendPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CristalyseChart()
            .data(data)
            .mapping(x: mappingKeyX, y: mappingKeyY, color: mappingKeyColour)
            .geomPoint(
              size: 8.0,
              alpha: 0.8,
              shape: pointShape,
              borderWidth: 1.5,
            )
            .scaleXContinuous()
            .scaleYContinuous()
            .theme(
              darkTheme
                  ? ChartTheme.solarizedDarkTheme()
                  : ChartTheme.solarizedLightTheme(),
            )
            .legend(position: legendPosition)
            .build(),
      ),
    );
  }
}
