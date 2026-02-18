import 'package:elaros_mobile_app/ui/test_page_two/view_model/test_page_two_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPageTwo extends StatefulWidget {
  const TestPageTwo({super.key});

  @override
  State<TestPageTwo> createState() => _TestPageTwoState();
}

class _TestPageTwoState extends State<TestPageTwo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TestPageTwoViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Test Page')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.getHeartRateLastNDays(7);
                          },
                          child: const Text('Get Heart Rate Last 7 Days'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.getHeartRateLastNHours(24);
                          },
                          child: const Text('Get Heart Rate Last 24 Hours'),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.getHeartRateBetweenDates(
                              DateTime.now().subtract(const Duration(days: 7)),
                              DateTime.now(),
                            );
                          },
                          child: const Text('Get Heart Rate Between Dates'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(viewModel.message),

                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (viewModel.isError)
                  Text(viewModel.errorMessage)
                else
                  Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: viewModel.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(viewModel.data[index].date.toString()),
                          subtitle: Text(
                            viewModel.data[index].value.toString(),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// import 'package:elaros_mobile_app/ui/core/graphs/pie_chart.dart';
// import 'package:flutter/material.dart';

// class TestPageTwo extends StatefulWidget {
//   const TestPageTwo({super.key});

//   @override
//   State<TestPageTwo> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPageTwo> {
//   var datasetScatterAndLine = [
//     {'x': 1, 'y': 2, 'category': 'A'},
//     {'x': 2, 'y': 3, 'category': 'B'},
//     {'x': 3, 'y': 4, 'category': 'C'},
//     {'x': 4, 'y': 5, 'category': 'D'},
//     {'x': 5, 'y': 6, 'category': 'E'},
//     {'x': 10, 'y': 2, 'category': 'A'},
//     {'x': 20, 'y': 3, 'category': 'B'},
//     {'x': 30, 'y': 4, 'category': 'C'},
//     {'x': 40, 'y': 5, 'category': 'D'},
//     {'x': 50, 'y': 6, 'category': 'E'},
//   ];

//   List<Map<String, dynamic>> datasetBar = [
//     {'quarter': 'Q1', 'revenue': 120, 'product': 'Widget A'},
//     {'quarter': 'Q2', 'revenue': 150, 'product': 'Widget A'},
//     {'quarter': 'Q3', 'revenue': 80, 'product': 'Widget A'},
//     {'quarter': 'Q4', 'revenue': 110, 'product': 'Widget A'},
//     {'quarter': 'Q1', 'revenue': 80, 'product': 'Widget B'},
//     {'quarter': 'Q2', 'revenue': 110, 'product': 'Widget B'},
//     {'quarter': 'Q3', 'revenue': 80, 'product': 'Widget B'},
//     {'quarter': 'Q4', 'revenue': 110, 'product': 'Widget B'},
//   ];

//   List<Map<String, dynamic>> datasetPie = [
//     {'category': 'A', 'value': 10},
//     {'category': 'B', 'value': 20},
//     {'category': 'C', 'value': 30},
//     {'category': 'D', 'value': 40},
//     {'category': 'E', 'value': 50},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     PieChart pieChart = PieChart(
//       data: datasetPie,
//       mappingKeyX: 'category',
//       mappingKeyY: 'value',
//       mappingKeyColour: 'category',
//       outerRadius: 200,
//     );

//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Page')),
//       body: Scaffold(body: Center(child: pieChart)),
//     );
//   }
// }
