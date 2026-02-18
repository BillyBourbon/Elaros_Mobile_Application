import 'package:flutter/material.dart';

class HRZone {
  final int number;
  final String name;
  final Color color;
  final Color bgColor;
  final Color textColor;
  final String description;
  final double lowerPct; // Lower % of HRR
  final double upperPct; // Upper % of HRR

  const HRZone({
    required this.number,
    required this.name,
    required this.color,
    required this.bgColor,
    required this.textColor,
    required this.description,
    required this.lowerPct,
    required this.upperPct,
  });
}

/// Zone definitions with HRR percentages matching the profile page formula.
const List<HRZone> hrZoneDefinitions = [
  HRZone(
    number: 1, name: 'Recovery',
    color: Color(0xff10b981), bgColor: Color(0xffd1fae5), textColor: Color(0xff065f46),
    description: 'Safe for rest and recovery',
    lowerPct: 0.0, upperPct: 0.30,
  ),
  HRZone(
    number: 2, name: 'Sustainable',
    color: Color(0xff3b82f6), bgColor: Color(0xffdbeafe), textColor: Color(0xff1e40af),
    description: 'Light daily activities',
    lowerPct: 0.30, upperPct: 0.50,
  ),
  HRZone(
    number: 3, name: 'Caution',
    color: Color(0xfff59e0b), bgColor: Color(0xfffef3c7), textColor: Color(0xff92400e),
    description: 'Monitor and limit time',
    lowerPct: 0.50, upperPct: 0.65,
  ),
  HRZone(
    number: 4, name: 'Risk',
    color: Color(0xffef4444), bgColor: Color(0xfffee2e2), textColor: Color(0xff991b1b),
    description: 'Reduce activity immediately',
    lowerPct: 0.65, upperPct: 0.80,
  ),
  HRZone(
    number: 5, name: 'Overexertion',
    color: Color(0xffdc2626), bgColor: Color(0xfffecaca), textColor: Color(0xff7f1d1d),
    description: 'Stop and rest now',
    lowerPct: 0.80, upperPct: 1.0,
  ),
];
