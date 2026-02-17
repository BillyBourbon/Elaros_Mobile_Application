import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

enum ScaleType { continuous, ordinal }

abstract class BaseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  final String mappingKeyX;
  final String mappingKeyY;
  final String? mappingKeyColour;

  final bool darkTheme;

  final LegendPosition legendPosition;
  final LabelCallback? labelYMap;
  final LabelCallback? labelXMap;

  final double? yScaleMin;
  final double? yScaleMax;
  final double? xScaleMin;
  final double? xScaleMax;

  final ScaleType yScaleType;
  final ScaleType xScaleType;

  const BaseChart({
    super.key,
    required this.data,
    required this.mappingKeyX,
    required this.mappingKeyY,
    this.mappingKeyColour,
    this.darkTheme = true,
    this.legendPosition = LegendPosition.bottom,
    this.labelYMap,
    this.labelXMap,
    this.yScaleMin,
    this.xScaleMin,
    this.yScaleMax,
    this.xScaleMax,
    this.yScaleType = ScaleType.continuous,
    this.xScaleType = ScaleType.continuous,
  });

  CristalyseChart buildChart() {
    CristalyseChart chart = CristalyseChart()
        .data(data)
        .mapping(x: mappingKeyX, y: mappingKeyY, color: mappingKeyColour ?? '')
        .theme(
          darkTheme
              ? ChartTheme.solarizedDarkTheme()
              : ChartTheme.solarizedLightTheme(),
        )
        .legend(position: legendPosition);

    if (yScaleType == ScaleType.ordinal) {
      chart.scaleYOrdinal(labels: labelYMap);
    } else {
      chart.scaleYContinuous(min: yScaleMin, max: yScaleMax, labels: labelYMap);
    }

    if (xScaleType == ScaleType.ordinal) {
      chart.scaleXOrdinal(labels: labelXMap);
    } else {
      chart.scaleXContinuous(min: xScaleMin, max: xScaleMax, labels: labelXMap);
    }

    return chart;
  }
}
