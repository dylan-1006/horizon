import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/edit_profile_screen.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/fitbit_authorisation_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/fitbit_auth_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/widget_tree.dart';
import 'dart:ui';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isNotificationsOn = true;
  bool _isNotificationsEnabled = false;

  late bool isAccountFitBitAuthorised;
  Map<String, dynamic> userData = {};
  late String userId;

  @override
  void initState() {
    super.initState();
    checkNotificationPermission();
  }

  Future<void> checkNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation?.areNotificationsEnabled();

    setState(() {
      _isNotificationsEnabled = granted ?? false;
      _isNotificationsOn = granted ?? false;
    });
  }

  Future<void> requestNotificationPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation?.requestNotificationsPermission();

    setState(() {
      _isNotificationsEnabled = granted ?? false;
      _isNotificationsOn = granted ?? false;
    });
  }

  Future<void> fetchUserData() async {
    userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);
    isAccountFitBitAuthorised = userData['isFitBitAuthorised'] ?? false;
  }

  Future<bool> _showReauthoriseConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Fitbit Account Already Linked",
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                  "You have already linked a Fitbit account with Horizon. Reauthorize with a different Fitbit account?\n\nNote: One Fitbit account can only connect to one Horizon user."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    DatabaseUtils.updateDocument(
                        "users", userId, {"isFitBitAuthorised": false});
                    NavigationUtils.push(context, FitbitAuthorisationScreen());
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Constants.primaryColor),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showFitbitAuthRequiredDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Fitbit Authorization Required",
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              "Please authorize your Fitbit account first to access this feature."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                NavigationUtils.push(context, FitbitAuthorisationScreen());
              },
              child: const Text(
                "Authorize Now",
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSensitivityResetDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Success",
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Model sensitivity has been reset successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

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

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Confirm Logout",
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "Are you sure you want to log out of your account?",
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Constants.accentColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                        color: Color(0xffFF2B51), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(onRefresh: () {});
          } else {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                shadowColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: Container(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      NavigationUtils.pushAndRemoveUntil(
                          context, const WidgetTree());
                    },
                  ),
                ),
              ),
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/settings_screen_background.png'),
                        fit: BoxFit.cover)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black.withOpacity(0.7),
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Dialog(
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 250,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: userData[
                                                          'profileImgUrl'] !=
                                                      null
                                                  ? NetworkImage(
                                                      userData['profileImgUrl'])
                                                  : const AssetImage(
                                                      'assets/images/default_user_profile_picture.jpg'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Constants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Close",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            margin: const EdgeInsets.only(top: 85),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: userData['profileImgUrl'] != null
                                        ? NetworkImage(
                                            userData['profileImgUrl'])
                                        : const AssetImage(
                                            'assets/images/default_user_profile_picture.jpg'))),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Text(
                            userData['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          child: Text(
                            userData['email'],
                            style: TextStyle(
                                fontSize: 14, color: Constants.accentColor),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60)),
                                elevation: 0),
                            onPressed: () async {
                              NavigationUtils.push(
                                  context, EditProfileScreen());
                            },
                            child: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        header: Container(
                            margin: const EdgeInsets.only(left: 20, top: 40),
                            child: Text(
                              "Preferences",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.accentColor,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.normal),
                            )),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        children: [
                          CupertinoListTile.notched(
                            title: const Text(
                              "Push Notifications",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff9fa0ac),
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                              ),
                            ),
                            trailing: CupertinoSwitch(
                                activeColor: Constants.primaryColor,
                                value: _isNotificationsOn,
                                onChanged: (bool value) async {
                                  if (value && !_isNotificationsEnabled) {
                                    await requestNotificationPermission();
                                  } else {
                                    setState(() {
                                      _isNotificationsOn = value;
                                    });
                                  }
                                }),
                          ),
                          CupertinoListTile.notched(
                            title: const Text(
                              "FitBit Health",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: Constants.accentColor,
                                        width: 0.5)),
                                width: double.infinity,
                                height: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/icons/fitbit_icon.png")),
                                )),
                            trailing: const CupertinoListTileChevron(),
                            onTap: () async {
                              if (!isAccountFitBitAuthorised) {
                                NavigationUtils.push(
                                    context, FitbitAuthorisationScreen());
                              } else {
                                _showReauthoriseConfirmationDialog();
                              }
                            },
                            additionalInfo: Text(isAccountFitBitAuthorised
                                ? "Connected"
                                : "Not connected"),
                          ),
                          CupertinoListTile.notched(
                            title: const Text(
                              "Rest Prediction Sensitivity",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                Icons.restart_alt_rounded,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              if (!isAccountFitBitAuthorised) {
                                _showFitbitAuthRequiredDialog();
                              } else {
                                await DatabaseUtils.updateDocument(
                                    "users",
                                    userId,
                                    {"modelNotificationSensitivity": 0.8});
                                _showSensitivityResetDialog();
                              }
                            },
                          ),
                        ],
                      ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: Colors.transparent,
                        header: Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              "Help",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Constants.accentColor,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.normal),
                            )),
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 25),
                        children: [
                          CupertinoListTile.notched(
                            title: const Text(
                              "Privacy Policy",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff007AFF),
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                Icons.privacy_tip_outlined,
                                color: Colors.white,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.info_outline,
                              color: Color(0xff007aff),
                            ),
                            onTap: () {
                              _showPrivacyPolicyDialog();
                            },
                          ),
                          CupertinoListTile.notched(
                            title: const Text(
                              "Terms & Conditions",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff007AFF),
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                Icons.description_outlined,
                                color: Colors.white,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.info_outline,
                              color: Color(0xff007aff),
                            ),
                            onTap: () {
                              _showTermsAndConditionsDialog();
                            },
                          ),
                          CupertinoListTile.notched(
                            onTap: () async {
                              bool confirmed =
                                  await _showLogoutConfirmationDialog();
                              if (confirmed) {
                                await Auth().signOut();
                                NavigationUtils.pushAndRemoveUntil(
                                    context, const WidgetTree());
                              }
                            },
                            title: const Text(
                              "Logout",
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  color: Color(0xffFF2B51),
                                  fontWeight: FontWeight.w500),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffFF2B51),
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                size: 22,
                                Icons.logout_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
