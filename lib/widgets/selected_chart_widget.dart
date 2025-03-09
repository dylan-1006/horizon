import 'package:flutter/material.dart';
import 'package:horizon/widgets/hrv_chart_widget.dart';
import 'package:horizon/widgets/sleep_chart_widget.dart';
import 'package:horizon/widgets/activity_chart_widget.dart';

class SelectedChartWidget extends StatelessWidget {
  final String chartType;
  final List<Map<String, dynamic>> chartData;

  const SelectedChartWidget({
    super.key,
    required this.chartType,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
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
}
