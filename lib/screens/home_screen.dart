import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/icons/app_icon.png'))),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/home_screen_background.png'),
                  fit: BoxFit.cover))),
    );
  }
}
