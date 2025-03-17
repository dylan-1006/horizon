import 'dart:convert';
import 'package:horizon/utils/notifications_utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PredictionUtils {
  Future<Map<String, dynamic>?> sendPredictionRequest(
      List<double> features) async {
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

  Future<void> processPredictionResult(Map<String, dynamic> result) async {
    if (result.containsKey('prediction') && result.containsKey('probability')) {
      final prediction = result['prediction'][0];
      final probabilities = result['probability'][0];

      // Check if prediction is 1 (anxiety) and probability > 0.8
      if (prediction == 1 &&
          probabilities.length > 1 &&
          probabilities[1] > 0.8) {
        await _showAnxietyNotification();
        return;
      }

      // Alternative check: if second probability value is high regardless of prediction
      // if (probabilities.length > 1 && probabilities[1] > 0.8) {
      //   await _showAnxietyNotification();
      // }
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
