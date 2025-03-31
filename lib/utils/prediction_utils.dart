import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/notifications_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PredictionUtils {
  late String userId;
  Map<String, dynamic> userData = {};
  late double modelNotificationSensitivity;
  Future<Map<String, dynamic>?> sendPredictionRequest(
      List<num> features) async {
    try {
      final response = await http.post(
        Uri.parse('https://predict-function-lmxo3hxzeq-uc.a.run.app/predict'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'features': features,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // Automatically process the prediction result
        await processPredictionResult(result);
        return result;
      } else {
        print('Prediction request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error sending prediction request: $e');
      return null;
    }
  }

  static List<num> extractNumericValues(Map<String, dynamic> data) {
    //Iterate through the data map and extract numeric values
    return data.values
        .where((value) => value is num) // Filter only numeric values
        .map((numValue) => numValue as num) // Cast to num type
        .toList();
  }

  Future<void> fetchUserData() async {
    userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);
    modelNotificationSensitivity = userData['modelNotificationSensitivity'];
  }

  Future<void> processPredictionResult(Map<String, dynamic> result) async {
    await fetchUserData();

    if (result.containsKey('prediction') && result.containsKey('probability')) {
      final prediction = result['prediction'][0];
      final probabilities = result['probability'][0];

      // Check if prediction is 1 (anxiety) and probability > 0.8
      if (prediction == 1 &&
          probabilities.length > 1 &&
          probabilities[1] > modelNotificationSensitivity) {
        await _showAnxietyNotification();
        return;
      }
    }
  }

  Future<void> _showAnxietyNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'High Anxiety Detected',
      'Your anxiety levels seem high. Try some relaxation techniques.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'anxiety_alert_channel',
          'Anxiety Alerts',
          channelDescription: 'Notifies when high anxiety is detected',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
    );
  }
}
