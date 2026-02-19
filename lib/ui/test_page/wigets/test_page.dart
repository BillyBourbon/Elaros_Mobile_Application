import 'package:cristalyse/cristalyse.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/area_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/bar_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/heat_map_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/line_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/pie_chart.dart';
import 'package:elaros_mobile_app/ui/common/widgets/graph_wigets/scatter_chart.dart';
import 'package:elaros_mobile_app/utils/helpers/date_utilities.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final double chartHeight = 300;
  final bool darkTheme = false;

  List<Map<String, dynamic>> datasetScatterAndLine = [
    {'x': 1, 'y': 2, 'category': 'A'},
    {'x': 2, 'y': 3, 'category': 'B'},
    {'x': 3, 'y': 4, 'category': 'C'},
    {'x': 4, 'y': 5, 'category': 'D'},
    {'x': 5, 'y': 6, 'category': 'E'},
    {'x': 10, 'y': 2, 'category': 'A'},
    {'x': 20, 'y': 3, 'category': 'B'},
    {'x': 30, 'y': 4, 'category': 'C'},
    {'x': 40, 'y': 5, 'category': 'D'},
    {'x': 50, 'y': 6, 'category': 'E'},
  ];
  List<Map<String, dynamic>> datasetLine = [
    {'x': 1, 'y': 2},
    {'x': 2, 'y': 3},
    {'x': 3, 'y': 4},
    {'x': 4, 'y': 5},
    {'x': 5, 'y': 6},
    {'x': 10, 'y': 2},
    {'x': 20, 'y': 3},
    {'x': 30, 'y': 4},
    {'x': 40, 'y': 5},
    {'x': 50, 'y': 6},
  ];

  List<Map<String, dynamic>> datasetBar = [
    {'quarter': 'Q1', 'revenue': 120, 'product': 'Widget A'},
    {'quarter': 'Q2', 'revenue': 150, 'product': 'Widget A'},
    {'quarter': 'Q3', 'revenue': 80, 'product': 'Widget A'},
    {'quarter': 'Q4', 'revenue': 110, 'product': 'Widget A'},
    {'quarter': 'Q1', 'revenue': 80, 'product': 'Widget B'},
    {'quarter': 'Q2', 'revenue': 110, 'product': 'Widget B'},
    {'quarter': 'Q3', 'revenue': 80, 'product': 'Widget B'},
    {'quarter': 'Q4', 'revenue': 110, 'product': 'Widget B'},
  ];

  List<Map<String, dynamic>> datasetPie = [
    {'category': 'A', 'value': 10},
    {'category': 'B', 'value': 20},
    {'category': 'C', 'value': 30},
    {'category': 'D', 'value': 40},
    {'category': 'E', 'value': 50},
    {'category': 'F', 'value': 60},
    {'category': 'G', 'value': 70},
    {'category': 'H', 'value': 80},
    {'category': 'I', 'value': 90},
  ];
  List<Map<String, dynamic>> stepCountDataWithDates = [
    {'x': '01-01-2024 00:30', 'y': 'Week 1', 'value': 8432},
    {'x': '02-01-2024 00:30', 'y': 'Week 1', 'value': 7215},
    {'x': '03-01-2024 00:30', 'y': 'Week 1', 'value': 9567},
    {'x': '04-01-2024 00:30', 'y': 'Week 1', 'value': 10234},
    {'x': '05-01-2024 00:30', 'y': 'Week 1', 'value': 8876},
    {'x': '06-01-2024 00:30', 'y': 'Week 1', 'value': 12453},
    {'x': '07-01-2024 00:30', 'y': 'Week 1', 'value': 13567},
    {'x': '08-01-2024 00:30', 'y': 'Week 2', 'value': 9123},
    {'x': '09-01-2024 00:30', 'y': 'Week 2', 'value': 8345},
    {'x': '10-01-2024 00:30', 'y': 'Week 2', 'value': 10987},
    {'x': '11-01-2024 00:30', 'y': 'Week 2', 'value': 11765},
    {'x': '12-01-2024 00:30', 'y': 'Week 2', 'value': 9543},
    {'x': '13-01-2024 00:30', 'y': 'Week 2', 'value': 14321},
    {'x': '14-01-2024 00:30', 'y': 'Week 2', 'value': 12890},
    {'x': '15-01-2024 00:30', 'y': 'Week 3', 'value': 7654},
    {'x': '16-01-2024 00:30', 'y': 'Week 3', 'value': 8234},
    {'x': '17-01-2024 00:30', 'y': 'Week 3', 'value': 9876},
    {'x': '18-01-2024 00:30', 'y': 'Week 3', 'value': 10456},
    {'x': '19-01-2024 00:30', 'y': 'Week 3', 'value': 11234},
    {'x': '20-01-2024 00:30', 'y': 'Week 3', 'value': 15432},
    {'x': '21-01-2024 00:30', 'y': 'Week 3', 'value': 13210},
    {'x': '22-01-2024 00:30', 'y': 'Week 4', 'value': 8912},
    {'x': '23-01-2024 00:30', 'y': 'Week 4', 'value': 9456},
    {'x': '24-01-2024 00:30', 'y': 'Week 4', 'value': 10345},
    {'x': '25-01-2024 00:30', 'y': 'Week 4', 'value': 11876},
    {'x': '26-01-2024 00:30', 'y': 'Week 4', 'value': 9765},
    {'x': '27-01-2024 00:30', 'y': 'Week 4', 'value': 16789},
    {'x': '28-01-2024 00:30', 'y': 'Week 4', 'value': 14321},
    {'x': '29-01-2024 00:30', 'y': 'Week 5', 'value': 9123},
    {'x': '30-01-2024 00:30', 'y': 'Week 5', 'value': 10345},
    {'x': '31-01-2024 00:30', 'y': 'Week 5', 'value': 8765},
    {'x': '01-02-2024 00:30', 'y': 'Week 5', 'value': 11234},
    {'x': '02-02-2024 00:30', 'y': 'Week 5', 'value': 15432},
    {'x': '03-02-2024 00:30', 'y': 'Week 5', 'value': 13210},
    {'x': '04-02-2024 00:30', 'y': 'Week 5', 'value': 8912},
  ];

  List<Map<String, dynamic>> getFormatedHeatMapData() {
    var data = stepCountDataWithDates
        .map(
          (e) => {
            'x': e['x'],
            'day': DateUtilities.getWeekDayFromDateTime(
              DateUtilities.getDateTimeFromString(e['x']),
            ).toString().substring(0, 3),
            'y': e['y'],
            'value': e['value'],
          },
        )
        .toList();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Heat Map Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: HeatMapChart(
                data: getFormatedHeatMapData(),
                mappingKeyX: 'day',
                mappingKeyY: 'y',
                mappingKeyColour: 'value',
                legendPosition: null,
                darkTheme: darkTheme,
              ),
            ),

            const SizedBox(height: 8),

            const Text('Scatter Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: ScatterChart(
                data: datasetScatterAndLine,
                mappingKeyX: 'x',
                mappingKeyY: 'y',
                mappingKeyColour: 'category',
                darkTheme: darkTheme,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Line Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: LineChart(
                data: datasetLine,
                mappingKeyX: 'x',
                mappingKeyY: 'y',
                mappingKeyColour: 'category',
                darkTheme: darkTheme,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Area Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: AreaChart(
                data: datasetLine,
                mappingKeyX: 'x',
                mappingKeyY: 'y',
                mappingKeyColour: 'category',
                darkTheme: darkTheme,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Bar Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: chartHeight,
              child: BarChart(
                data: datasetBar,
                mappingKeyX: 'quarter',
                mappingKeyY: 'revenue',
                mappingKeyColour: 'product',
                darkTheme: darkTheme,
                barStyle: BarStyle.grouped,
                horizontalBars: true,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Pie Chart'),
            const SizedBox(height: 8),
            SizedBox(
              height: 400,
              child: PieChart(
                data: datasetPie,
                mappingKeyX: 'category',
                mappingKeyY: 'value',
                outerRadius: 100,
                darkTheme: darkTheme,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
