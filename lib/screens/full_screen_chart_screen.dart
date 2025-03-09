import 'package:flutter/material.dart';
import 'package:horizon/widgets/hrv_chart_widget.dart';
import 'package:horizon/widgets/sleep_chart_widget.dart';
import 'package:horizon/widgets/activity_chart_widget.dart';

class FullScreenChartScreen extends StatelessWidget {
  final String chartType;
  final List<Map<String, dynamic>> chartData;

  const FullScreenChartScreen({
    super.key,
    required this.chartType,
    required this.chartData,
  });

  Widget _getSelectedChart() {
    switch (chartType) {
      case "HRV":
        return HRVChartWidget(hrvData: chartData);
      case "Sleep":
        return SleepChartWidget(sleepData: chartData);
      case "Activity":
        return ActivityChartWidget(activityData: chartData);
      default:
        return const Center(child: Text("No data available"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$chartType Chart")),
      body: Center(child: _getSelectedChart()),
    );
  }
}
