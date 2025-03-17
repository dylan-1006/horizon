import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/breathing_exercise_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/widget_tree.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications(BuildContext context) async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) async {
      print('onDidReceiveNotificationResponse: $details');
      _showAnxietyConfirmationDialog(context);
    },
  );
}


Future<bool> _showAnxietyConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Fitbit Account Already Linked",
              style: TextStyle(
                color: Constants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
                "Your anxiety levels seem high. Try some relaxation techniques."),
            actions: [
              TextButton(
                onPressed: () {
                  NavigationUtils.pushAndRemoveUntil(
                      context, const WidgetTree());
                },
                child: const Text(
                  "False Alarm",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  NavigationUtils.push(context, BreathingExerciseScreen());
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Constants.primaryColor),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
