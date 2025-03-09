import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:horizon/constants.dart';

class HRVChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> hrvData;

  HRVChartWidget({required this.hrvData});

  @override
  _HRVChartWidgetState createState() => _HRVChartWidgetState();
}

class _HRVChartWidgetState extends State<HRVChartWidget> {
  List<Color> gradientColors = [
    Constants.primaryColor,
    Constants.secondaryColor
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: SizedBox(
            width: 60,
            height: 34,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < widget.hrvData.length) {
                return Text(widget.hrvData[value.toInt()]['date'],
                    style: TextStyle(fontSize: 10));
              }
              return Container();
            },
            reservedSize: 22,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: widget.hrvData.length.toDouble() - 1,
      minY: 0,
      maxY: widget.hrvData
          .map((e) => e['dailyRmssd'])
          .reduce((a, b) => a > b ? a : b)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: widget.hrvData
              .asMap()
              .entries
              .map((entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value['dailyRmssd'].toDouble(),
                  ))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    double avg = widget.hrvData
            .map((e) => e['dailyRmssd'].toDouble())
            .reduce((a, b) => a + b) /
        widget.hrvData.length;

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < widget.hrvData.length) {
                return Text(widget.hrvData[value.toInt()]['date'],
                    style: TextStyle(fontSize: 10));
              }
              return Container();
            },
            reservedSize: 22,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: 0,
      maxX: widget.hrvData.length.toDouble() - 1,
      minY: 0,
      maxY: widget.hrvData
          .map((e) => e['dailyRmssd'])
          .reduce((a, b) => a > b ? a : b)
          .toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: widget.hrvData
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), avg))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
