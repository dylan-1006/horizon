import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:horizon/constants.dart';

class SleepChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> sleepData;

  SleepChartWidget({required this.sleepData});

  @override
  _SleepChartWidgetState createState() => _SleepChartWidgetState();
}

class _SleepChartWidgetState extends State<SleepChartWidget> {
  int _currentWeekOffset = 0; // 0 = current week, -1 = previous week, etc.
  final int _maxPastWeeks = -4; // 4 weeks = ~30 days
  final int _maxFutureWeeks = 1; // Only allow one week into the future

  List<Map<String, dynamic>> generateCompleteDateRange() {
    // Remove this check to allow generating date ranges even without data
    // if (widget.sleepData.isEmpty) return [];

    // Create map with double values
    final sleepByDate = <String, double>{};
    // Only populate sleepByDate if we have data
    if (widget.sleepData.isNotEmpty) {
      for (final entry in widget.sleepData) {
        final date = entry['dateOfSleep'] as String;
        final durationMs = entry['duration'] as int;
        final durationHours = durationMs / 3600000;

        sleepByDate.update(
          date,
          (value) => value + durationHours,
          ifAbsent: () => durationHours,
        );
      }
    }

    // Get the current date and adjust for week offset
    DateTime currentDate =
        DateTime.now().add(Duration(days: 7 * _currentWeekOffset));
    DateTime startDate = currentDate;

    // Adjust to start from Monday
    int daysToSubtract = startDate.weekday - 1;
    if (daysToSubtract > 0) {
      startDate = startDate.subtract(Duration(days: daysToSubtract));
    }

    // Always use 6 days (for a week view)
    DateTime endDate = startDate.add(Duration(days: 6));

    // Generate complete range with double zeros
    final completeRange = <Map<String, dynamic>>[];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);

      completeRange.add({
        'date': dateStr,
        'duration': sleepByDate[dateStr] ?? 0.0,
        'hasData': sleepByDate.containsKey(dateStr),
      });
    }

    return completeRange;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completeData = generateCompleteDateRange();
    List<Map<String, dynamic>> displayedData = completeData.take(7).toList();

    // Calculate date range for display
    DateTime startDate = DateTime.parse(displayedData.first['date']);
    DateTime endDate = DateTime.parse(displayedData.last['date']);
    String dateRangeText =
        "${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}";

    // Calculate average only from days that have sleep data
    List<double> sleepDurations = completeData
        .where((item) => item['hasData'])
        .map((item) => item['duration'] as double)
        .toList();

    double averageSleep = sleepDurations.isEmpty
        ? 0
        : sleepDurations.reduce((a, b) => a + b) / sleepDurations.length;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity == null) return;

        // Swipe right (to see previous weeks)
        if (details.primaryVelocity! > 0 &&
            _currentWeekOffset > _maxPastWeeks) {
          setState(() {
            _currentWeekOffset--;
          });
        }
        // Swipe left (to see future weeks)
        else if (details.primaryVelocity! < 0 &&
            _currentWeekOffset < _maxFutureWeeks) {
          setState(() {
            _currentWeekOffset++;
          });
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
                    averageSleep == 0
                        ? "No data"
                        : "${averageSleep.floor()} h ${(averageSleep % 1 * 60).floor()} min",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_currentWeekOffset != 0)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentWeekOffset = 0;
                      });
                    },
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
                        Text(
                          'Today',
                          style: TextStyle(
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                ? Center(child: Text("No sleep data available"))
                : AspectRatio(
                    aspectRatio: 1.8,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: displayedData.asMap().entries.map((entry) {
                          int index = entry.key;
                          double hours = entry.value['duration'];
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: hours,
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
                                rodStackItems: [],
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
                              color: Constants.primaryColor,
                              width: 1,
                            ),
                            tooltipPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final hours = rod.toY;
                              final hoursInt = hours.floor();
                              final minutes = ((hours - hoursInt) * 60).round();
                              return BarTooltipItem(
                                minutes > 0
                                    ? '$hoursInt h $minutes m'
                                    : '$hoursInt h',
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
                              y: averageSleep,
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
                                    "${averageSleep.floor()} h ${(averageSleep % 1 * 60).floor()} min",
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
