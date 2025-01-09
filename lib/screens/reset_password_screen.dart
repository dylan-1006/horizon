import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: Container(
          child: BackButton(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.black.withOpacity(0.4), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(
                weight: 12,
                size: 42,
                Icons.fingerprint_rounded,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 20),
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Open Sans'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 35, right: 35, top: 10),
              child: Text(
                textAlign: TextAlign.justify,
                "No worries! We'll send you reset instructions",
                style: TextStyle(
                  color: Constants.accentColor,
                  fontSize: 15,
                  fontFamily: 'Open Sans',
                ),
              ),
            ),
            FormBuilder(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(left: 35, right: 35, top: 40),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red, width: 1))),
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
                onPressed: () {
                  _formKey.currentState?.saveAndValidate();
                  if (_formKey.currentState!.validate()) {
                    final formData = _formKey.currentState!.value;
                    print(formData['email']);
                    try {
                      Auth().resetPassword(email: formData['email']);
                    } on FirebaseException catch (e) {
                      print("error" + e.message.toString());
                    }
                  }
                  ;
                },
                child: Center(
                  child: const Text(
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
