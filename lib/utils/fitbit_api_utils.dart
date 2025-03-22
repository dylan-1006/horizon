import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:horizon/utils/fitbit_auth_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FitbitApiUtils {
  static const String baseUrlV1 = "https://api.fitbit.com/1/user/-";
  static const String baseUrlV1_2 = "https://api.fitbit.com/1.2/user/-";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Fetches latest access token and makes API requests
  Future<Map<String, dynamic>?> _fetchFitbitData(String userId, String endpoint,
      {bool useSleepApi = false}) async {
    try {
      String? accessToken = await FitbitAuthUtils.refreshAccessToken(userId);
      final baseUrl = useSleepApi ? baseUrlV1_2 : baseUrlV1;

      if (accessToken == null) {
        print("Failed to retrieve access token");
        return null;
      }

      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Fitbit API request failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching Fitbit data: $e");
      return null;
    }
  }

  /// Fetch Heart Rate Variability (HRV)
  Future<Map<String, dynamic>?> fetchHRV(String userId, String date) async {
    return await _fetchFitbitData(userId, "/hrv/date/$date.json");
  }

  /// Fetch Heart Rate)
  Future<Map<String, dynamic>?> fetchHeartRate(
      String userId, String date) async {
    return await _fetchFitbitData(
        userId, "/activities/heart/date/$date/1d.json");
  }

  /// Fetch Sleep Data
  Future<Map<String, dynamic>?> fetchSleepData(
      String userId, String date) async {
    return await _fetchFitbitData(userId, "/sleep/date/$date.json",
        useSleepApi: true);
  }

  /// Fetch Activity Data
  Future<Map<String, dynamic>?> fetchActivityData(
      String userId, String resourcePath, String date) async {
    return await _fetchFitbitData(
        userId, "/activities/$resourcePath/date/$date/1d.json");
  }

  Future<Map<String, dynamic>?> fetchSkinTemperatureData(
      String userId, String date) async {
    return await _fetchFitbitData(userId, "/temp/skin/date/$date.json");
  }

  /// Fetch all relevant Fitbit data for the day
  Future<Map<String, Map<String, dynamic>?>> fetchAllData(
      String userId, String date) async {
    final results = await Future.wait([
      fetchHeartRate(userId, date),
      fetchHRV(userId, date),
      fetchSleepData(userId, date),
      fetchActivityData(userId, 'steps', date),
      fetchActivityData(userId, 'minutesLightlyActive', date),
      fetchActivityData(userId, 'minutesFairlyActive', date),
      fetchActivityData(userId, 'minutesVeryActive', date),
      fetchActivityData(userId, 'minutesSedentary', date),
      fetchSkinTemperatureData(userId, date),
    ]);

    return {
      'heart_rate': results[0],
      'hrv': results[1],
      'sleep': results[2],
      'activity': {
        'steps': results[3],
        'minutesLightlyActive': results[4],
        'minutesFairlyActive': results[5],
        'minutesVeryActive': results[6],
        'minutesSedentary': results[7],
      },
      'skin_temperature': results[8],
    };
  }

  /// Helper function to generate date range strings
  String _getDateRange(int days) {
    String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: days)));
    return "$startDate/$endDate";
  }

  /// Fetch HRV Data for the last 30 days
  Future<Map<String, dynamic>?> fetchHRVLast30Days(String userId) async {
    return await _fetchFitbitData(
        userId, "/hrv/date/${_getDateRange(30)}.json");
  }

  /// Fetch Sleep Data for the last 30 days
  Future<Map<String, dynamic>?> fetchSleepLast30Days(String userId) async {
    return await _fetchFitbitData(
        userId, "/sleep/date/${_getDateRange(30)}.json",
        useSleepApi: true);
  }

  /// Fetch Activity (Steps, Calories, etc.) for the last 30 days
  Future<Map<String, dynamic>?> fetchActivityLast30Days(
      String userId, String resourcePath) async {
    return await _fetchFitbitData(
        userId, "/activities/$resourcePath/date/${_getDateRange(30)}.json");
  }

  /// Fetch all relevant Fitbit data for the last 30 days
  Future<Map<String, Map<String, dynamic>?>> fetchAllDataLast30Days(
      String userId) async {
    final results = await Future.wait([
      fetchSleepLast30Days(userId),
      fetchHRVLast30Days(userId),
      fetchActivityLast30Days(userId, 'steps'),
    ]);

    return {
      'sleep': results[0],
      'hrv': results[1],
      'activity': results[2],
    };
  }

  /// Process all Fitbit data to extract only the needed fields
  Map<String, dynamic> processAllData(
      Map<String, Map<String, dynamic>?> rawData) {
    Map<String, dynamic> processedData = {};

    // Process heart rate data
    if (rawData['heart_rate'] != null) {
      try {
        var restingHeartRate = rawData['heart_rate']!['activities-heart'][0]
            ['value']['restingHeartRate'];
        processedData['resting_heart_rate'] = restingHeartRate ?? 80;
      } catch (e) {
        print("Error processing heart rate data: $e");
      }
    }

    // Process HRV data
    if (rawData['hrv'] != null) {
      try {
        var hrvRmssd = rawData['hrv']!['hrv'][0]['value']['deepRmssd'];
        processedData['hrvRmssd'] = hrvRmssd;
      } catch (e) {
        print("Error processing hrv data: $e");
      }
    }

    // Process sleep data
    if (rawData['sleep'] != null) {
      try {
        var sleepSummary = rawData['sleep']!['sleep'][0];
        processedData['sleep_duration'] = sleepSummary['duration'];

        // Add the additional fields from the first sleep record if available
        if (rawData['sleep']!['sleep'] != null &&
            rawData['sleep']!['sleep'].isNotEmpty) {
          var sleepRecord = rawData['sleep']!['sleep'][0];
          processedData['minutes_asleep'] = sleepRecord['minutesAsleep'];
          processedData['minutes_awake'] = sleepRecord['minutesAwake'];
        }
        processedData['sleep_efficiency'] = sleepSummary['efficiency'];
      } catch (e) {
        print("Error processing sleep data: $e");
      }
    }

    // Process activity data
    if (rawData['activity'] != null) {
      try {
        // Steps
        if (rawData['activity']!['steps'] != null) {
          var activitySteps =
              rawData['activity']!['steps']['activities-steps'][0];
          processedData['steps'] = double.parse(activitySteps['value']);
        }

        // // Active minutes
        if (rawData['activity']!['minutesLightlyActive'] != null) {
          processedData['minutes_lightly_active'] = double.parse(
              rawData['activity']!['minutesLightlyActive']![
                  'activities-minutesLightlyActive'][0]['value']);
        }

        if (rawData['activity']!['minutesFairlyActive'] != null) {
          processedData['minutes_fairly_active'] = double.parse(
              rawData['activity']!['minutesFairlyActive']![
                  'activities-minutesFairlyActive'][0]['value']);
        }

        if (rawData['activity']!['minutesVeryActive'] != null) {
          processedData['minutes_very_active'] = double.parse(
              rawData['activity']!['minutesVeryActive']![
                  'activities-minutesVeryActive'][0]['value']);
        }

        if (rawData['activity']!['minutesSedentary'] != null) {
          processedData['minutes_sedentary'] = double.parse(
              rawData['activity']!['minutesSedentary']![
                  'activities-minutesSedentary'][0]['value']);
        }
      } catch (e) {
        print("Error processing activity data: $e");
      }
    }

    // Process skin temperature data
    if (rawData['skin_temperature'] != null) {
      try {
        var tempData = rawData['skin_temperature']!['tempSkin'][0]['value'];
        if (tempData.isNotEmpty) {
          processedData['skin_temperature'] = tempData['nightlyRelative'];
        }
      } catch (e) {
        print("Error processing skin temperature data: $e");
      }
    }

    return processedData;
  }
}
