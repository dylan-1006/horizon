import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/fitbit_authorisation_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/fitbit_auth_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/widget_tree.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  bool _isNotificationsOn = true;

  late bool isAccountFitBitAuthorised;
  Map<String, dynamic> userData = {};
  late String userId;
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

  void initState() {
    super.initState();
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
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: Container(
                  child: const BackButton(
                    color: Colors.black,
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
                        child: Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.only(top: 85),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: userData['profileImgUrl'] != null
                                      ? NetworkImage(userData['profileImgUrl'])
                                      : const AssetImage(
                                          'assets/images/default_user_profile_picture.jpg'))),
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
                            onPressed: () async {},
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
                                onChanged: (bool value) {
                                  setState(
                                    () {
                                      _isNotificationsOn = !_isNotificationsOn;
                                    },
                                  );
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
                          ),
                          CupertinoListTile.notched(
                            title: const Text(
                              "Support",
                              style: TextStyle(fontFamily: 'Open Sans'),
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff007AFF),
                                  borderRadius: BorderRadius.circular(7)),
                              width: double.infinity,
                              height: double.infinity,
                              child: const Icon(
                                size: 20,
                                Icons.help_rounded,
                                color: Colors.white,
                              ),
                            ),
                            trailing: const CupertinoListTileChevron(),
                            onTap: () {},
                          ),
                          CupertinoListTile.notched(
                            onTap: () async {
                              await Auth().signOut();
                              NavigationUtils.pushAndRemoveUntil(
                                  context, const WidgetTree());
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
