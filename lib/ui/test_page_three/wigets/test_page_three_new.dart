import 'package:elaros_mobile_app/ui/test_page_three/view_model/test_page_three_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestPageThree extends StatefulWidget {
  const TestPageThree({super.key});

  @override
  State<TestPageThree> createState() => _TestPageThreeState();
}

class _TestPageThreeState extends State<TestPageThree> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TestPageThreeViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Test Page 3')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.getLatestHeartRate();
                          },
                          child: const Text('Get latest heart rate'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.getLastHourOfMinuteData();
                    },
                    child: const Text('Get last hour of minute data'),
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.getLatestStepCount();
                    },
                    child: const Text('Get latest step count'),
                  ),
                ),

                const SizedBox(height: 20),

                Text(viewModel.message),

                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (viewModel.isError)
                  Text(viewModel.errorMessage),

                if (viewModel.data.isNotEmpty)
                  SizedBox(
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

                if (viewModel.groupedData.isNotEmpty)
                  SizedBox(
                    height: 300,
                    // child: TableFromMap(data: viewModel.groupedData),
                    child: ListView.builder(
                      itemCount: viewModel.groupedData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(viewModel.groupedData[index]['time']),
                          subtitle: Text(
                            viewModel.groupedData[index].toString(),
                          ),
                        );
                      },
                    ),
                  ),

                if (viewModel.stepCountData.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: viewModel.stepCountData.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            viewModel.stepCountData[index].date.toString(),
                          ),
                          subtitle: Text(
                            viewModel.stepCountData[index].value.toString(),
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
