import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HRVChart extends StatelessWidget {
  final List<Map<String, dynamic>> hrvData;

  HRVChart({required this.hrvData});

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
                  return Text(hrvData[value.toInt()]['date'],
                      style: TextStyle(fontSize: 10));
                },
                reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: hrvData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value['dailyRmssd'].toDouble(),
                      ))
                  .toList(),
              isCurved: true,
              color: Colors.purple,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
