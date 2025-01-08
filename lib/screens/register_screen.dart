import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                margin: EdgeInsets.only(top: 70),
                child: Center(
                  child: Image.asset(
                    'assets/icons/register_icon.png',
                    width: 160,
                  ),
                )),
            Center(
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Garamond',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                try {
                  Auth().signInWithGoogle();
                } on FirebaseException catch (e) {
                  print("error" + e.message.toString());
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
                        margin: EdgeInsets.only(right: 15),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/google_icon.png',
                            height: 30,
                          ),
                        )),
                    Text(
                      "Continue with Google",
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
              margin: const EdgeInsets.only(left: 35, right: 35, top: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(color: Constants.accentColor),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: Text(
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
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 25),
                    alignment: Alignment.centerLeft,
                    child: FormBuilderTextField(
                      name: "name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                      decoration: InputDecoration(
                          isDense: true,
                          labelStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 15,
                              color: Constants.accentColor),
                          labelText: "Name",
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
                      Auth().createUserWithEmailAndPassword(
                          name: formData['name'],
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
                    "Sign up",
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
              margin: EdgeInsets.only(bottom: 60, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 15,
                        color: Colors.black),
                  ),
                  Container(
                    child: Text("Sign In",
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
