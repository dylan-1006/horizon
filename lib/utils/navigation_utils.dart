import 'package:flutter/material.dart';

class NavigationUtils {
  static void pushAndRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
      (route) => false,
    );
  }

  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  static void pushFadeTransition(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  static Future<dynamic> pushWithResult(
      BuildContext context, Widget screen) async {
    dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
    return result;
  }

  static void popUntil(BuildContext context, int popCount) {
    int count = 0;
    Navigator.popUntil(context, (route) => count++ == popCount);
  }

  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }
}
