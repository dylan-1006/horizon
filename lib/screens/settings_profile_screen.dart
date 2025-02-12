import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/widget_tree.dart';

class SettingsProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SettingsProfileScreen({super.key, required this.userData});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  bool _isNotificationsOn = false;
  @override
  Widget build(BuildContext context) {
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
                image:
                    AssetImage('assets/images/settings_screen_background.png'),
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
                          image: widget.userData['profileImgUrl'] != null
                              ? NetworkImage(widget.userData['profileImgUrl'])
                              : const AssetImage(
                                  'assets/images/default_user_profile_picture.jpg'))),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    widget.userData['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    widget.userData['email'],
                    style:
                        TextStyle(fontSize: 14, color: Constants.accentColor),
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
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        elevation: 0),
                    onPressed: () async {},
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white, fontSize: 13),
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
                      "Fit Bit Health",
                      style: TextStyle(fontFamily: 'Open Sans'),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: Constants.accentColor, width: 0.5)),
                      width: double.infinity,
                      height: double.infinity,
                      child: const Icon(
                        size: 20,
                        Icons.heart_broken,
                        color: Colors.red,
                      ),
                    ),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () {},
                    additionalInfo: const Text("Not connected"),
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
                margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
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
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WidgetTree()),
                          (route) => false);
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
}
