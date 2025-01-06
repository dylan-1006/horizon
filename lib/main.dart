import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/home_screen.dart';
import 'package:horizon/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:horizon/screens/register_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
    return RegisterScreen();
  }
}
