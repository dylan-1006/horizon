import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:horizon/constants.dart';

class ActivityChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> activityData;

  const ActivityChartWidget({Key? key, required this.activityData})
      : super(key: key);

  @override
  _ActivityChartWidgetState createState() => _ActivityChartWidgetState();
}

class _ActivityChartWidgetState extends State<ActivityChartWidget> {
  int _currentWeekOffset = 0;
  final int _maxPastWeeks = -4;
  final int _maxFutureWeeks = 1;

  List<Map<String, dynamic>> generateCompleteDateRange() {
    final stepsByDate = <String, int>{};
    for (final entry in widget.activityData) {
      final date = entry['dateTime'] as String;
      final steps = int.parse(entry['steps'] as String);
      stepsByDate[date] = steps;
    }

    DateTime currentDate =
        DateTime.now().add(Duration(days: 7 * _currentWeekOffset));
    DateTime startDate = currentDate;

    int daysToSubtract = startDate.weekday - 1;
    if (daysToSubtract > 0) {
      startDate = startDate.subtract(Duration(days: daysToSubtract));
    }

    DateTime endDate = startDate.add(Duration(days: 6));

    final completeRange = <Map<String, dynamic>>[];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);

      completeRange.add({
        'date': dateStr,
        'steps': stepsByDate[dateStr] ?? 0,
        'hasData': stepsByDate.containsKey(dateStr),
      });
    }

    return completeRange;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completeData = generateCompleteDateRange();
    List<Map<String, dynamic>> displayedData = completeData.take(7).toList();

    DateTime startDate = DateTime.parse(displayedData.first['date']);
    DateTime endDate = DateTime.parse(displayedData.last['date']);
    String dateRangeText =
        "${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}";

    List<int> stepCounts = completeData
        .where((item) => item['hasData'])
        .map((item) => item['steps'] as int)
        .toList();

    double averageSteps = stepCounts.isEmpty
        ? 0
        : stepCounts.reduce((a, b) => a + b) / stepCounts.length;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > 0 &&
            _currentWeekOffset > _maxPastWeeks) {
          setState(() => _currentWeekOffset--);
        } else if (details.primaryVelocity! < 0 &&
            _currentWeekOffset < _maxFutureWeeks) {
          setState(() => _currentWeekOffset++);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    averageSteps == 0
                        ? "No data"
                        : "${averageSteps.toStringAsFixed(0)} steps",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_currentWeekOffset != 0)
                  TextButton(
                    onPressed: () => setState(() => _currentWeekOffset = 0),
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: Constants.primaryColor.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.today,
                            size: 16, color: Constants.primaryColor),
                        SizedBox(width: 4),
                        Text('Today',
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
              ],
            ),
            Container(
              child: Text(dateRangeText,
                  style: TextStyle(color: Constants.accentColor)),
            ),
            SizedBox(height: 32),
            displayedData.isEmpty
                ? Center(child: Text("No activity data availablsse"))
                : AspectRatio(
                    aspectRatio: 1.8,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: displayedData.asMap().entries.map((entry) {
                          int index = entry.key;
                          int steps = entry.value['steps'];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: steps.toDouble(),
                                width: 28,
                                color: entry.value['hasData']
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                gradient: entry.value['hasData']
                                    ? LinearGradient(
                                        colors: [
                                          Constants.primaryColor,
                                          Colors.blueAccent.withOpacity(0.15)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                              )
                            ],
                            barsSpace: 4,
                          );
                        }).toList(),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor:
                                Constants.primaryColor.withOpacity(0.9),
                            tooltipRoundedRadius: 8,
                            tooltipBorder: BorderSide(
                                color: Constants.primaryColor, width: 1),
                            tooltipPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final steps = rod.toY;
                              return BarTooltipItem(
                                '${steps.toInt()} steps',
                                TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: averageSteps,
                              color: Constants.primaryColor.withOpacity(0.5),
                              strokeWidth: 1,
                              dashArray: [8, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topLeft,
                                padding:
                                    const EdgeInsets.only(left: 0, bottom: 5),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                                labelResolver: (line) =>
                                    "${averageSteps.toStringAsFixed(0)} steps",
                              ),
                            ),
                          ],
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= displayedData.length)
                                  return Container();

                                DateTime date = DateTime.parse(
                                    displayedData[value.toInt()]['date']);
                                return Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    DateFormat('E').format(date),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Constants.accentColor),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
