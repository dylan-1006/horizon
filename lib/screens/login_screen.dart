import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/register_screen.dart';
import 'package:horizon/screens/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Image.asset(
                    'assets/icons/login_icon.png',
                    width: 160,
                  ),
                )),
            const Center(
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
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
                    alignment: Alignment.centerLeft,
                    child: FormBuilderTextField(
                      name: "email",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email()
                      ]),
                      decoration: InputDecoration(
                          isDense: true,
                          labelStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              color: Constants.accentColor),
                          labelText: "Email",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Constants.primaryColor, width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.black, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    alignment: Alignment.centerLeft,
                    child: FormBuilderTextField(
                      obscureText: _isObscure,
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(8,
                            errorText:
                                "Password must be at least 8 characters long ")
                      ]),
                      decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            child: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 20,
                              color: Constants.accentColor,
                            ),
                          ),
                          isDense: true,
                          labelStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              color: Constants.accentColor),
                          labelText: "Password",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Constants.primaryColor, width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.black, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(right: 35, top: 8),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPasswordScreen()));
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Constants.accentColor),
                      ),
                    ))),
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
                  _formKey.currentState?.saveAndValidate();
                  if (_formKey.currentState!.validate()) {
                    final formData = _formKey.currentState!.value;
                    print(formData['email']);
                    print(formData['password']);
                    try {
                      await Auth().signInWithEmailAndPassword(
                          email: formData['email'],
                          password: formData['password']);
                    } on FirebaseAuthException catch (e) {
                      DelightToastBar(
                          autoDismiss: true,
                          builder: (context) => const ToastCard(
                              color: Colors.red,
                              leading: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              title: Text(
                                "Incorrect email or password.",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))).show(context);

                      print("error${e.message}");
                    }
                  }
                },
                child: const Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(color: Constants.accentColor),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 13),
                      child: const Text(
                        "or",
                        style: TextStyle(fontSize: 14),
                      )),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(color: Constants.accentColor),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  Auth().signInWithGoogle();
                } on FirebaseException catch (e) {
                  print("error${e.message}");
                }
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/google_icon.png',
                            height: 30,
                          ),
                        )),
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 15,
                          color: Constants.accentColor),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont have an account? ",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: Container(
                      child: const Text("Sign up",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Constants.primaryColor)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
