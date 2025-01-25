import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/widget_tree.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _emailSent = false;
  String? emailAddress;
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: Container(
          child: const BackButton(),
        ),
      ),
      body: SingleChildScrollView(
        child: _emailSent
            ? Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35, top: 50),
                      child: const Text("Check your inbox",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
                      child: Text(
                          "A link to reset your password was sent to $emailAddress",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: const Icon(
                        size: 102,
                        Icons.email,
                        color: Constants.primaryColor,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 50),
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
                            "Done",
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
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 8),
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          try {
                            await Auth()
                                .resetPassword(email: emailAddress.toString());

                            DelightToastBar(
                                autoDismiss: true,
                                builder: (context) => const ToastCard(
                                    color: Constants.primaryColor,
                                    leading: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      "We've sent the link again. Check your email.",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ))).show(context);
                            setState() {}
                          } on FirebaseException catch (e) {
                            print("error${e.message}");
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
                        },
                        child: const Center(
                          child: Text(
                            "Resend Email",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Constants.primaryColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.4), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      size: 42,
                      Icons.fingerprint_rounded,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Open Sans'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      "No worries! Enter your email address and we'll send you a link to reset your password",
                      style: TextStyle(
                        color: Constants.accentColor,
                        fontSize: 15,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                  ),
                  FormBuilder(
                    key: formKey,
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 40),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        formKey.currentState?.saveAndValidate();
                        if (formKey.currentState!.validate()) {
                          final formData = formKey.currentState!.value;
                          emailAddress = formData['email'];
                          print(formData['email']);
                          try {
                            await Auth()
                                .resetPassword(email: formData['email']);
                            setState(() {
                              _emailSent = true;
                            });
                          } on FirebaseException catch (e) {
                            print("error${e.message}");
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
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Reset password",
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
    );
  }
}
