import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/login_screen.dart';
import 'package:horizon/widget_tree.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _accountCreated = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return _accountCreated
        ? Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('assets/images/gradient_background.png'),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 170),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      width: 200,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: const Text(
                      textAlign: TextAlign.center,
                      "Welcome to Horizon! ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                      child: const Text(
                        textAlign: TextAlign.center,
                        "We're thrilled to have you on board and can't wait for you to explore and achieve great things with us.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 35, right: 35, bottom: 30),
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WidgetTree()));
                      },
                      child: const Center(
                        child: Text(
                          "Explore Horizon",
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
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/register_icon.png',
                          width: 160,
                        ),
                      )),
                  const Center(
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
                        print("error${e.message}");
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12)),
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 30),
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
                            decoration:
                                BoxDecoration(color: Constants.accentColor),
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
                            decoration:
                                BoxDecoration(color: Constants.accentColor),
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
                          margin: const EdgeInsets.only(
                              left: 35, right: 35, top: 25),
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Constants.primaryColor,
                                        width: 1.5)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1))),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 35, right: 35, top: 20),
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Constants.primaryColor,
                                        width: 1.5)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1))),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 35, right: 35, top: 20),
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Constants.primaryColor,
                                        width: 1.5)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1))),
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
                      onPressed: _accountCreated
                          ? null
                          : () async {
                              _formKey.currentState?.saveAndValidate();
                              if (_formKey.currentState!.validate()) {
                                final formData = _formKey.currentState!.value;
                                print(formData['email']);
                                print(formData['password']);
                                try {
                                  await Auth().createUserWithEmailAndPassword(
                                      name: formData['name'],
                                      email: formData['email'],
                                      password: formData['password']);
                                  setState(() {
                                    _accountCreated = true;
                                  });
                                } on FirebaseException catch (e) {
                                  if (e.code == 'email-already-in-use') {
                                    DelightToastBar(
                                        autoDismiss: true,
                                        builder: (context) => const ToastCard(
                                            color: Colors.red,
                                            leading: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              "An account has already been created with this email address.",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))).show(context);
                                  } else {
                                    DelightToastBar(
                                        autoDismiss: true,
                                        builder: (context) => const ToastCard(
                                            color: Colors.red,
                                            leading: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                              "Something went wrong. Please try again.",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))).show(context);
                                  }

                                  print("error${e.message}");
                                }
                              }
                            },
                      child: const Center(
                        child: Text(
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
                    margin: const EdgeInsets.only(bottom: 60, top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
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
                                    builder: (context) => WidgetTree()));
                          },
                          child: Container(
                            child: Text("Sign In",
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
