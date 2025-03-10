import 'package:flutter/material.dart';
import 'package:horizon/widgets/selected_chart_widget.dart';

class ChartSection extends StatefulWidget {
  final Map<String, Map<String, dynamic>?>
      fitbitData; // Fitbit data from HomeScreen

  const ChartSection({super.key, required this.fitbitData});

  @override
  _ChartSectionState createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  String selectedChartType = "HRV"; // Default chart type

  List<Map<String, dynamic>> _getChartData() {
    final rawData = widget.fitbitData[selectedChartType.toLowerCase()];
    if (rawData == null) return [];

    switch (selectedChartType) {
      case "HRV":
        return _parseHRVData(rawData);
      case "Sleep":
        return _parseSleepData(rawData);
      case "Activity":
        return _parseActivityData(rawData);
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _parseHRVData(Map<String, dynamic> data) {
    if (data['hrv'] == null) return [];
    return (data['hrv'] as List)
        .map((entry) => {
              'date': entry['dateTime'],
              'dailyRmssd': entry['value']['dailyRmssd'],
              'deepRmssd': entry['value']['deepRmssd'],
            })
        .toList();
  }

  List<Map<String, dynamic>> _parseSleepData(Map<String, dynamic> data) {
    if (data['sleep'] == null) return [];

    return (data['sleep'] as List)
        .map((entry) => {
              'dateOfSleep': entry['dateOfSleep'],
              'duration': entry['duration'], // Milliseconds
            })
        .toList();
  }

  List<Map<String, dynamic>> _parseActivityData(Map<String, dynamic> data) {
    print(data);
    if (data['activities-steps'] == null) return [];
    return (data['activities-steps'] as List)
        .map((entry) => {
              'dateTime': entry['dateTime'],
              'steps': entry['value'],
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> chartData = _getChartData();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.only(left: 20, right: 25, bottom: 15, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // 25% opacity black
            blurRadius: 4, // Blur: 4
            offset: const Offset(0, 4), // X: 0, Y: 4
            spreadRadius: 0, // Spread: 0
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: selectedChartType,
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 3,
                style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                onChanged: (value) {
                  setState(() {
                    selectedChartType = value!;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: "HRV",
                    child: Text(
                      "Heart Rate Variability",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Sleep",
                    child: Text(
                      "Avg Sleep Time",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Activity",
                    child: Text(
                      "Activity",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: chartData.isEmpty
                ? Center(child: Text("No data available"))
                : SelectedChartWidget(
                    chartType: selectedChartType, chartData: chartData),
          ),
        ],
      ),
    );
  }
}
