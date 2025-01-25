import 'package:flutter/material.dart';

class SettingsProfileScreen extends StatelessWidget {
  const SettingsProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: Container(
          child: const BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/home_screen_background.png'),
                fit: BoxFit.cover)),
      ),
    );
  }
}
