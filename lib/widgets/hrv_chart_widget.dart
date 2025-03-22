import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:horizon/constants.dart';
import 'package:intl/intl.dart';

class HRVChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> hrvData;

  const HRVChartWidget({Key? key, required this.hrvData}) : super(key: key);

  @override
  _HRVChartWidgetState createState() => _HRVChartWidgetState();
}

class _HRVChartWidgetState extends State<HRVChartWidget> {
  bool showAvg = false;

  // Colors for different HRV zones
  final Color normalColor = Colors.green;
  final Color elevatedColor = Colors.orange;
  final Color highColor = Colors.red;

  // Calculate min, max, and average values
  late final double minHRV;
  late final double maxHRV;
  late double avgHRV;
  late double weeklyAvgHRV;

  // Add week offset controls like sleep chart
  int _currentWeekOffset = 0;
  final int _maxPastWeeks = -4;
  final int _maxFutureWeeks = 1;

  // Update the HRV zones with new thresholds
  final Map<String, Color> hrvZones = {
    'Low': Colors.red, // Below 80% of baseline
    'Normal': Colors.yellow, // 80-120% of baseline
    'Good': Colors.green, // Above 120% of baseline
  };

  // Add threshold constants
  final double lowThreshold = 0.8; // 80% of baseline
  final double highThreshold = 1.2; // 120% of baseline

  // Add these new variables for statistics
  late String todayRange;
  late String weeklyRange;

  // Add new variables for HRV calculations
  late double todayHrvAverage;
  late double weeklyBaselineHrv;

  void calculateHrvStatistics(List<Map<String, dynamic>> displayedData) {
    // Calculate average only from days that have HRV data
    List<Map<String, dynamic>> daysWithData =
        displayedData.where((item) => item['hasData'] == true).toList();

    // Calculate Today's HRV Average from the displayed week
    if (daysWithData.isNotEmpty) {
      final latestData = daysWithData.last;
      final dailyRmssd = latestData['dailyRmssd'] as double? ?? 0.0;
      final deepRmssd = latestData['deepRmssd'] as double? ?? 0.0;
      todayHrvAverage = (dailyRmssd + deepRmssd) / 2;
    } else {
      todayHrvAverage = 0.0;
    }

    // Calculate Weekly Average from the displayed week
    if (daysWithData.isNotEmpty) {
      double sumHrv = 0.0;
      int valueCount = 0;

      for (var data in daysWithData) {
        final dailyRmssd = data['dailyRmssd'] as double? ?? 0.0;
        final deepRmssd = data['deepRmssd'] as double? ?? 0.0;

        // Only count values that are greater than 0
        if (dailyRmssd > 0) {
          sumHrv += dailyRmssd;
          valueCount++;
        }

        if (deepRmssd > 0) {
          sumHrv += deepRmssd;
          valueCount++;
        }
      }

      // Only divide by the actual number of values we added
      weeklyBaselineHrv = valueCount > 0 ? sumHrv / valueCount : 0.0;
    } else {
      weeklyBaselineHrv = 0.0;
    }

    // Update the display strings
    todayRange =
        todayHrvAverage == 0 ? "No data" : "${todayHrvAverage.floor()} ms";
    weeklyRange =
        weeklyBaselineHrv == 0 ? "No data" : "${weeklyBaselineHrv.floor()} ms";
  }

  @override
  void initState() {
    super.initState();
    calculateHrvStatistics(widget.hrvData);
  }

  @override
  void didUpdateWidget(HRVChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hrvData != oldWidget.hrvData) {
      calculateHrvStatistics(widget.hrvData);
    }
  }

  // Get all valid HRV values as a list
  List<double> _getValidHrvValues() {
    return widget.hrvData
        .map((e) => e['dailyRmssd'] is num ? e['dailyRmssd'].toDouble() : null)
        .where((value) =>
            value != null && value > 0) // Filter out null and zero values
        .cast<double>() // Cast to List<double>
        .toList();
  }

  // Format date from the data structure
  String _formatDate(Map<String, dynamic> dataPoint) {
    try {
      if (dataPoint.containsKey('date') && dataPoint['date'] is String) {
        final dateStr = dataPoint['date'];
        // Parse the date string
        DateTime date = DateTime.parse(dateStr);
        // Format to show just the time or hour
        return DateFormat('h a').format(date); // e.g., "6 AM"
      }
      return '';
    } catch (e) {
      print('Error formatting date: $e');
      return '';
    }
  }

  // Add method to generate complete date range similar to sleep chart
  List<Map<String, dynamic>> generateCompleteDateRange() {
    final hrvByDate = <String, Map<String, dynamic>>{};

    if (widget.hrvData.isNotEmpty) {
      for (final entry in widget.hrvData) {
        final date = entry['date'] as String;
        hrvByDate[date] = entry;
      }
    }

    // Get current date and adjust for week offset
    DateTime currentDate =
        DateTime.now().add(Duration(days: 7 * _currentWeekOffset));
    DateTime startDate = currentDate;

    // Adjust to start from Monday
    int daysToSubtract = startDate.weekday - 1;
    if (daysToSubtract > 0) {
      startDate = startDate.subtract(Duration(days: daysToSubtract));
    }

    // Generate week view
    DateTime endDate = startDate.add(Duration(days: 6));

    final completeRange = <Map<String, dynamic>>[];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final currentDate = startDate.add(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);

      final hasData = hrvByDate.containsKey(dateStr) &&
          (hrvByDate[dateStr]?['dailyRmssd'] != null ||
              hrvByDate[dateStr]?['deepRmssd'] != null);

      completeRange.add({
        'date': dateStr,
        'dailyRmssd': hrvByDate[dateStr]?['dailyRmssd'] ?? 0.0,
        'deepRmssd': hrvByDate[dateStr]?['deepRmssd'] ?? 0.0,
        'hasData': hasData, // Explicitly set as boolean
      });
    }

    return completeRange;
  }

  Color _getBarColor(double value, double baselineValue) {
    if (value <= 0) return Colors.transparent;

    // Calculate the percentage of baseline
    double percentageOfBaseline = baselineValue > 0 ? value / baselineValue : 0;

    // Return color based on percentage of baseline
    if (percentageOfBaseline < lowThreshold) {
      return LinearGradient(
        colors: [hrvZones['Low']!, hrvZones['Low']!.withOpacity(0.15)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).colors.first;
    } else if (percentageOfBaseline < highThreshold) {
      return LinearGradient(
        colors: [hrvZones['Normal']!, hrvZones['Normal']!.withOpacity(0.15)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).colors.first;
    } else {
      return LinearGradient(
        colors: [hrvZones['Good']!, hrvZones['Good']!.withOpacity(0.15)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).colors.first;
    }
  }

  // Update the bar chart configuration with null safety
  BarChartGroupData _generateBarGroup(
      MapEntry<int, Map<String, dynamic>> entry, double baselineValue) {
    int index = entry.key;
    Map<String, dynamic> data = entry.value;

    // Safely get the values with null checks
    double dailyRmssd = (data['dailyRmssd'] as num?)?.toDouble() ?? 0.0;
    bool hasData = data['hasData'] as bool? ?? false;

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: dailyRmssd,
          width: 28,
          color: hasData ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          gradient: hasData
              ? LinearGradient(
                  colors: [
                    _getBarColor(dailyRmssd, baselineValue),
                    _getBarColor(dailyRmssd, baselineValue).withOpacity(0.15)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
        )
      ],
      barsSpace: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> completeData = generateCompleteDateRange();
    List<Map<String, dynamic>> displayedData = completeData.take(7).toList();

    // Calculate statistics based on displayed data
    calculateHrvStatistics(displayedData);

    // Calculate date range for display
    DateTime startDate = DateTime.parse(displayedData.first['date'] as String);
    DateTime endDate = DateTime.parse(displayedData.last['date'] as String);
    String dateRangeText =
        "${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(endDate)}";

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity == null) return;

        if (details.primaryVelocity! > 0 &&
            _currentWeekOffset > _maxPastWeeks) {
          setState(() {
            _currentWeekOffset--;
          });
        } else if (details.primaryVelocity! < 0 &&
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayRange,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Average today',
                        style: TextStyle(
                          color: Constants.accentColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weeklyRange,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Weekly average',
                        style: TextStyle(
                          color: Constants.accentColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add Today button when not on current week
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
              margin: EdgeInsets.only(top: 20),
              child: Text(dateRangeText,
                  style: TextStyle(color: Constants.accentColor)),
            ),
            SizedBox(height: 20),

            // Legend Row
            buildLegendRow(),

            SizedBox(height: 35),

            // Chart
            AspectRatio(
              aspectRatio: 1.8,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: displayedData
                      .asMap()
                      .entries
                      .map((entry) =>
                          _generateBarGroup(entry, weeklyBaselineHrv))
                      .toList(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Constants.accentColor.withOpacity(0.3),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Constants.accentColor,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= displayedData.length)
                            return Container();
                          DateTime date = DateTime.parse(
                              displayedData[value.toInt()]['date'] as String);
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('E').format(date),
                              style: TextStyle(
                                fontSize: 12,
                                color: Constants.accentColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      tooltipRoundedRadius: 8,
                      tooltipBorder: BorderSide(
                        color: Constants.accentColor,
                        width: 1,
                      ),
                      tooltipPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final value = rod.toY;
                        final color = _getBarColor(value, weeklyBaselineHrv);

                        return BarTooltipItem(
                          '${value.floor()} ms',
                          TextStyle(
                            color: color,
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
                        y: weeklyBaselineHrv,
                        color: Constants.primaryColor.withOpacity(0.5),
                        strokeWidth: 1,
                        dashArray: [8, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 0, bottom: 5),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryColor,
                          ),
                          labelResolver: (line) =>
                              "Avg: ${weeklyBaselineHrv.floor()} ms",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '$label · $percentage',
          style: TextStyle(
            fontSize: 12,
            color: Constants.accentColor,
          ),
        ),
      ],
    );
  }

  Widget buildLegendRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildLegendItem('Low', '<80%', hrvZones['Low']!),
          SizedBox(width: 10),
          _buildLegendItem('Normal', '80-120%', hrvZones['Normal']!),
          SizedBox(width: 10),
          _buildLegendItem('Good', '>120%', hrvZones['Good']!),
        ],
      ),
    );
  }
}
