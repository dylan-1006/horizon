import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRefresh;

  const ErrorScreen({required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/error_screen_icon.png',
                height: 150,
              ),
              SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Please try again, and contact the support team if the problem persists.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Constants.accentColor),
              ),
              SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    onRefresh();
                  },
                  child: const Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
