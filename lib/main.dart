import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/edit_profile_screen.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/fitbit_authorisation_screen.dart';
import 'package:horizon/screens/home_screen.dart';
import 'package:horizon/screens/login_screen.dart';
import 'package:horizon/screens/register_screen.dart';
import 'package:horizon/screens/reset_password_screen.dart';
import 'package:horizon/utils/notifications_utils.dart';
import 'package:horizon/utils/prediction_utils.dart';
import 'package:horizon/widget_tree.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Open Sans',
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Constants.primaryColor,
            selectionColor: Constants.primaryColor,
            selectionHandleColor: Constants.primaryColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return WidgetTree();
    //return EditProfileScreen();
  }
}
