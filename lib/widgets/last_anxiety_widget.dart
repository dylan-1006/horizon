import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/breathing_exercise_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';

class LastAnxietyWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const LastAnxietyWidget({Key? key, this.onTap}) : super(key: key);

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
              margin: EdgeInsets.symmetric(vertical: 6),
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
                      Icons.warning_amber_rounded,
                      color: Constants.primaryColor,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Anxiety ",
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: "Free",
                          style: TextStyle(color: Constants.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Stack(children: [
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "days",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(width: 12, color: Constants.primaryColor),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
