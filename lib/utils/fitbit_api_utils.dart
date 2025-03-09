import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting
import 'package:horizon/utils/fitbit_auth_utils.dart';

class FitbitApiUtils {
  static const String baseUrl = "https://api.fitbit.com/1.2/user/-";

  /// Fetches latest access token and makes API requests
  Future<Map<String, dynamic>?> _fetchFitbitData(
      String userId, String endpoint) async {
    try {
      String? accessToken = await FitbitAuthUtils.refreshAccessToken(userId);

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

  /// Fetch Sleep Data
  Future<Map<String, dynamic>?> fetchSleepData(
      String userId, String date) async {
    return await _fetchFitbitData(userId, "/sleep/date/$date.json");
  }

  /// Fetch User Activity Data
  Future<Map<String, dynamic>?> fetchActivityData(
      String userId, String date) async {
    return await _fetchFitbitData(userId, "/activities/date/$date.json");
  }

  /// Fetch multiple data types at once (Sleep, HRV, Activity)
  Future<Map<String, dynamic>?> fetchHeartRate(
      String userId, String date) async {
    return await _fetchFitbitData(
        userId, "/activities/heart/date/$date/1d.json");
  }

  /// Fetch all relevant Fitbit data for the day
  Future<Map<String, Map<String, dynamic>?>> fetchAllData(
      String userId, String date) async {
    final results = await Future.wait([
      fetchSleepData(userId, date),
      fetchHRV(userId, date),
      fetchActivityData(userId, date),
      fetchHeartRate(userId, date),
    ]);

    return {
      'sleep': results[0],
      'hrv': results[1],
      'activity': results[2],
      'heart_rate': results[3],
    };
  }

  /// Fetches latest access token and makes API requests

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
        userId, "/sleep/date/${_getDateRange(30)}.json");
  }

  /// Fetch Activity (Steps, Calories, etc.) for the last 30 days
  Future<Map<String, dynamic>?> fetchActivityLast30Days(
      String userId, String resourcePath) async {
    return await _fetchFitbitData(
        userId, "/activities/$resourcePath/date/${_getDateRange(30)}.json");
  }

  /// Fetch Heart Rate for the last 30 days
  Future<Map<String, dynamic>?> fetchHeartRateLast30Days(String userId) async {
    return await _fetchFitbitData(
        userId, "/activities/heart/date/${_getDateRange(30)}.json");
  }

  /// Fetch all relevant Fitbit data for the last 30 days
  Future<Map<String, Map<String, dynamic>?>> fetchAllDataLast30Days(
      String userId) async {
    final results = await Future.wait([
      fetchSleepLast30Days(userId),
      // fetchHRVLast30Days(userId),
      fetchActivityLast30Days(userId, "steps"),
      fetchHeartRateLast30Days(userId),
    ]);

    return {
      'sleep': results[0],
      'hrv': results[1],
      'activities-steps': results[2],
      'heart_rate': results[3],
    };
  }
}
