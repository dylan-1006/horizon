import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/breathing_exercise_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/utils/fitbit_auth_utils.dart';
import 'package:horizon/auth.dart';

class LastAnxietyWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final int daysSinceLastAnxiety;

  const LastAnxietyWidget({
    Key? key,
    this.onTap,
    required this.daysSinceLastAnxiety,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // NavigationUtils.push(context, BreathingExerciseScreen(isTriggeredByPrediction: false));
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
              margin: EdgeInsets.only(top: 6, bottom: 13),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xffF0F0F0),
                    ),
                    margin: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.emoji_emotions_rounded,
                      color: Constants.primaryColor,
                    ),
                  ),
                  Text(
                    "Anxiety Free",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Open Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    value: daysSinceLastAnxiety / 365,
                    strokeWidth: 15,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.primaryColor),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$daysSinceLastAnxiety",
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        height: 0.9,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "days",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
