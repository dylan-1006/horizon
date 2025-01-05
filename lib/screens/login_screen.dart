import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Constants.primaryColor, width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    alignment: Alignment.centerLeft,
                    child: FormBuilderTextField(
                      obscureText: true,
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration: InputDecoration(
                          isDense: true,
                          labelStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              color: Constants.accentColor),
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Constants.primaryColor, width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1))),
                    ),
                  ),
                ],
              ),
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
              margin: const EdgeInsets.only(left: 35, right: 35, top: 30),
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  _formKey.currentState?.saveAndValidate();
                  if (_formKey.currentState!.validate()) {
                    final formData = _formKey.currentState!.value;
                    print(formData['email']);
                    print(formData['password']);
                    try {
                      Auth().signInWithEmailAndPassword(
                          email: formData['email'],
                          password: formData['password']);
                    } on FirebaseException catch (e) {
                      print("error" + e.message.toString());
                    }
                  }
                  ;
                },
                child: Center(
                  child: const Text(
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
      ),
    );
  }
}
