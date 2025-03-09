import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepChart extends StatelessWidget {
  final List<Map<String, dynamic>>
      sleepData; // List of sleep data (date, duration)

  SleepChart({required this.sleepData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(sleepData[value.toInt()]['date'],
                      style: TextStyle(fontSize: 10));
                },
                reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: sleepData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        (entry.value['duration'] /
                            3600000), // Convert ms to hours
                      ))
                  .toList(),
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
