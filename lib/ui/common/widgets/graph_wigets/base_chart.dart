import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/material.dart';

enum ScaleType { continuous, ordinal }

abstract class BaseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final ColorScheme? colorScheme;

  final String mappingKeyX;
  final String mappingKeyY;
  final String? mappingKeyColour;

  final bool darkTheme;

  final LegendPosition? legendPosition;
  final LabelCallback? labelYMap;
  final LabelCallback? labelXMap;

  final double? yScaleMin;
  final double? yScaleMax;
  final double? xScaleMin;
  final double? xScaleMax;

  final ScaleType yScaleType;
  final ScaleType xScaleType;

  final String? yAxisTitle;
  final String? xAxisTitle;

  const BaseChart({
    super.key,
    required this.data,
    required this.mappingKeyX,
    required this.mappingKeyY,
    required this.colorScheme,
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
    this.yAxisTitle,
    this.xAxisTitle,
  });

  ChartTheme buildChartTheme({
    required Color backgroundColor,
    required Color plotBackgroundColor,
    required Color primaryColor,
    required Color borderColor,
    required Color gridColor,
    required Color axisColor,
    required TextStyle axisTextStyle,
    required TextStyle axisLabelStyle,
    List<Color>? colorPalette,
  }) {
    final List<Color> defaultColorPalette = [
      const Color(0xFF007ACC),
      const Color(0xFFFF6B35),
      const Color(0xFF28A745),
      const Color(0xFFDC3545),
      const Color(0xFF6F42C1),
      const Color(0xFF20C997),
    ];

    return ChartTheme(
      backgroundColor: backgroundColor,
      plotBackgroundColor: plotBackgroundColor,
      primaryColor: primaryColor,
      borderColor: borderColor,
      gridColor: gridColor,
      axisColor: axisColor,
      axisTextStyle: axisTextStyle,
      axisLabelStyle: axisLabelStyle,

      colorPalette: colorPalette ?? defaultColorPalette,

      gridWidth: 0.2,
      axisWidth: 1.0,
      pointSizeDefault: 5.0,
      pointSizeMin: 3.0,
      pointSizeMax: 20.0,
      padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
    );
  }

  CristalyseChart buildChart({bool noMapping = false}) {
    final ChartTheme customThemeLight = buildChartTheme(
      backgroundColor: const Color(0xFFF8F9FA),
      plotBackgroundColor: Colors.white,
      primaryColor: const Color(0xFF007ACC),
      borderColor: const Color(0xFFE1E5E9),
      gridColor: const Color(0xFFF1F3F4),
      axisColor: const Color(0xFF5F6368),
      axisTextStyle: const TextStyle(
        fontSize: 11,
        color: Color(0xFF5F6368),
        fontWeight: FontWeight.w500,
      ),
      axisLabelStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF202124),
        fontWeight: FontWeight.w600,
      ),
    );

    final ChartTheme customThemeDark = buildChartTheme(
      backgroundColor: Colors.black38,
      plotBackgroundColor: Colors.black45,
      primaryColor: Colors.teal,
      borderColor: Colors.black38,
      gridColor: Colors.black26,
      axisColor: Colors.black38,
      axisTextStyle: const TextStyle(
        fontSize: 11,
        color: Color(0xFF5F6368),
        fontWeight: FontWeight.w500,
      ),
      axisLabelStyle: const TextStyle(
        fontSize: 13,
        color: Color(0xFF202124),
        fontWeight: FontWeight.w600,
      ),
    );

    ChartTheme chartTheme;

    if (colorScheme != null) {
      chartTheme = buildChartTheme(
        backgroundColor: colorScheme!.primary,
        plotBackgroundColor: colorScheme!.secondary,
        primaryColor: colorScheme!.surfaceBright,
        borderColor: colorScheme!.primary,
        gridColor: Colors.black54,
        axisColor: Colors.black87,
        axisTextStyle: const TextStyle(
          fontSize: 11,
          color: Color(0xFF5F6368),
          fontWeight: FontWeight.w500,
        ),
        axisLabelStyle: const TextStyle(
          fontSize: 13,
          color: Color(0xFF202124),
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      chartTheme = darkTheme ? customThemeDark : customThemeLight;
    }

    CristalyseChart chart = CristalyseChart().data(data).theme(chartTheme);
    if (!noMapping) {
      if (mappingKeyColour != null) {
        chart.mapping(x: mappingKeyX, y: mappingKeyY, color: mappingKeyColour);
      } else {
        chart.mapping(x: mappingKeyX, y: mappingKeyY);
      }
    }

    if (legendPosition != null) chart.legend(position: legendPosition);

    if (yScaleType == ScaleType.ordinal) {
      chart.scaleYOrdinal(labels: labelYMap, title: yAxisTitle ?? mappingKeyY);
    } else {
      chart.scaleYContinuous(
        min: yScaleMin,
        max: yScaleMax,
        labels: labelYMap,
        title: yAxisTitle ?? mappingKeyY,
        tickConfig: TickConfig(simpleLinear: true),
      );
    }

    if (xScaleType == ScaleType.ordinal) {
      chart.scaleXOrdinal(labels: labelXMap, title: xAxisTitle ?? mappingKeyX);
    } else {
      chart.scaleXContinuous(
        min: xScaleMin,
        max: xScaleMax,
        labels: labelXMap,
        title: xAxisTitle ?? mappingKeyX,
      );
    }

    return chart;
  }
}
