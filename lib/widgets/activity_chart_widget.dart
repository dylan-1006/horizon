import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityChart extends StatelessWidget {
  final List<Map<String, dynamic>> activityData; // List of steps data

  ActivityChart({required this.activityData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: activityData
              .asMap()
              .entries
              .map((entry) => BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value['steps'].toDouble(),
                        color: Colors.green,
                        width: 10,
                      ),
                    ],
                  ))
              .toList(),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(activityData[value.toInt()]['date'],
                      style: TextStyle(fontSize: 10));
                },
                reservedSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
