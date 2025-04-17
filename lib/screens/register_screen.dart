import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/login_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/widget_tree.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _accountCreated = false;
  bool _isObscure = true;

  Future<void> _showPrivacyPolicyDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Privacy Policy",
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Data Collection and Processing",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Horizon Health Technologies Ltd. (\"we,\" \"our,\" or \"the Company\") collects and processes physiological data from your Fitbit device solely for the purpose of providing anxiety monitoring services. All data acquisition occurs exclusively through Fitbit's authorized OAuth 2.0 authentication framework and only after obtaining your explicit consent as required under the General Data Protection Regulation (GDPR).",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "Data Subject Rights",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "As the data subject, you retain full ownership rights to your health information and are entitled to:\n- Withdraw your consent for data processing at any time\n- Request complete erasure of your personal data from our systems\n- Access and export your data in a machine-readable format\n- Lodge complaints with the relevant supervisory authority",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "Technical and Organizational Measures",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "The Company implements industry-standard encryption protocols for all data transmission and storage. Our machine learning algorithms undergo rigorous testing to minimize demographic bias and ensure equitable performance across diverse user populations.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "Service Limitations",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Our anxiety detection system operates with a target confidence threshold of 85%. The analytical results provided are intended for informational purposes only and do not constitute medical diagnosis or treatment recommendations. Users are advised to consult qualified healthcare professionals for clinical evaluation and intervention.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "Regulatory Compliance",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "This application is developed and maintained in strict accordance with the General Data Protection Regulation (EU) 2016/679, Fitbit's Developer Terms of Service, and applicable data protection legislation. For further information regarding our data handling practices or to exercise your rights as a data subject, please contact our Data Protection Officer at privacy@horizonhealth.com.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTermsAndConditionsDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Terms & Conditions",
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "1. Acceptance of Terms",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "By accessing or using Horizon's anxiety monitoring services, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, you may not use our services.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "2. Description of Service",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Horizon provides an anxiety monitoring and management platform that processes data from Fitbit wearable devices. Our service uses machine learning algorithms to analyze physiological data and identify potential anxiety patterns. The service is intended for informational purposes only and does not provide medical diagnosis or treatment.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "3. User Accounts",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account. We reserve the right to terminate accounts that violate our terms or policies.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "4. Data Usage and Privacy",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your use of our services is also governed by our Privacy Policy. By using Horizon, you consent to the collection and processing of your data as described in the Privacy Policy. We implement appropriate technical and organizational measures to protect your data.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "5. Limitations and Disclaimers",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "THE SERVICE IS PROVIDED \"AS IS\" WITHOUT WARRANTIES OF ANY KIND. WE DO NOT GUARANTEE THE ACCURACY, COMPLETENESS, OR RELIABILITY OF OUR ANXIETY DETECTION ALGORITHMS. HORIZON IS NOT A SUBSTITUTE FOR PROFESSIONAL MEDICAL ADVICE, DIAGNOSIS, OR TREATMENT. ALWAYS SEEK THE ADVICE OF QUALIFIED HEALTH PROVIDERS FOR ANY HEALTH-RELATED CONCERNS.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "6. Changes to Terms",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We reserve the right to modify these Terms & Conditions at any time. We will notify users of material changes through the application or via email. Your continued use of Horizon after such modifications constitutes your acceptance of the updated terms.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  "7. Governing Law",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "These Terms & Conditions shall be governed by and construed in accordance with the laws of the United Kingdom, without regard to its conflict of law provisions.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

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
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 20),
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
                        NavigationUtils.pushReplacement(
                            context, const WidgetTree());
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
                    margin: const EdgeInsets.only(left: 35, right: 35, top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 13,
                                color: Constants.accentColor,
                              ),
                              children: [
                                const TextSpan(
                                  text: "By signing up, you agree to our ",
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _showPrivacyPolicyDialog();
                                    },
                                ),
                                const TextSpan(
                                  text: " and ",
                                ),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _showTermsAndConditionsDialog();
                                    },
                                ),
                                const TextSpan(
                                  text: ".",
                                ),
                              ],
                            ),
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
                                print(formData['email'].trim());
                                print(formData['password']);
                                try {
                                  await Auth().createUserWithEmailAndPassword(
                                      name: formData['name'],
                                      email: formData['email'].trim(),
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
                            NavigationUtils.pushReplacement(
                                context, const WidgetTree());
                          },
                          child: Container(
                            child: const Text("Sign In",
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
