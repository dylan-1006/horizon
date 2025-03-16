import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.all(150),
        child: Center(
          child: LoadingIndicator(
            indicatorType: Indicator.ballGridPulse,
            colors: [Constants.primaryColor, Color.fromARGB(106, 48, 73, 234)],
          ),
        ),
      ),
    );
  }
}
