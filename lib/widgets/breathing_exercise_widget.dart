import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/breathing_exercise_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';

class BreathingExerciseWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const BreathingExerciseWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtils.push(context, BreathingExerciseScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // 25% opacity black
              blurRadius: 4, // Blur: 4
              offset: const Offset(0, 4), // X: 0, Y: 4
              spreadRadius: 0, // Spread: 0
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "Let's take a ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "breath",
                      style: TextStyle(color: Constants.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffCCD0F5),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff7984E4),
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constants.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "START",
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
