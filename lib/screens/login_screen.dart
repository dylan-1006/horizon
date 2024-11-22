import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset(
                  'assets/icons/login_icon.png',
                  width: 160,
                ),
              )),
          Center(
            child: Text(
              "Welcome back!",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Garamond',
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Form(
                child: Text(
              "Email",
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 15,
                  color: Constants.accentColor),
            )),
          ),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Form(
                child: Text(
              "Password",
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 15,
                  color: Constants.accentColor),
            )),
          ),
          Container(
              margin: const EdgeInsets.only(right: 35, top: 8),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Constants.accentColor),
                  ))),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
                color: Constants.primaryColor,
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
            alignment: Alignment.centerLeft,
            child: Form(
                child: Center(
              child: const Text(
                "Log In",
                style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )),
          ),
          Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(left: 35, right: 35, top: 70),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Form(
                child: Text(
              "Sign in with Google",
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 15,
                  color: Constants.accentColor),
            )),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont have an account? ",
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 15,
                      color: Colors.black),
                ),
                Container(
                  child: Text("Sign up",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Constants.primaryColor)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
