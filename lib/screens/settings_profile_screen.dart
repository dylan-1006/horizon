import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/widget_tree.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: Container(
          child: const BackButton(
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/settings_screen_background.png'),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  margin: EdgeInsets.only(top: 85),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/icons/app_icon.png'))),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "NAME OF USER",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    "user_email@gmail.com",
                    style:
                        TextStyle(fontSize: 14, color: Constants.accentColor),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        elevation: 0),
                    onPressed: () async {
                      await Auth().signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => WidgetTree()),
                          (route) => false);
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ),
              CupertinoListSection.insetGrouped(
                backgroundColor: Colors.transparent,
                header: Container(
                    margin: EdgeInsets.only(left: 20, top: 40),
                    child: Text(
                      "Preferences",
                      style: TextStyle(
                          fontSize: 14,
                          color: Constants.accentColor,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.normal),
                    )),
                margin: EdgeInsets.symmetric(horizontal: 25),
                children: [
                  CupertinoListTile.notched(
                    title: Text(
                      "Push Notifications",
                      style: TextStyle(fontFamily: 'Open Sans'),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff9fa0ac),
                          borderRadius: BorderRadius.circular(7)),
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.white,
                      ),
                    ),
                    trailing:
                        CupertinoSwitch(value: false, onChanged: (value) {}),
                  ),
                  CupertinoListTile.notched(
                    title: Text(
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
                      child: Icon(
                        size: 20,
                        Icons.heart_broken,
                        color: Colors.red,
                      ),
                    ),
                    trailing: CupertinoListTileChevron(),
                    onTap: () {},
                    additionalInfo: Text("Not connected"),
                  ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                backgroundColor: Colors.transparent,
                header: Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Help",
                      style: TextStyle(
                          fontSize: 14,
                          color: Constants.accentColor,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.normal),
                    )),
                margin: EdgeInsets.symmetric(horizontal: 25),
                children: [
                  CupertinoListTile.notched(
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(fontFamily: 'Open Sans'),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff007AFF),
                          borderRadius: BorderRadius.circular(7)),
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(
                        Icons.privacy_tip_outlined,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.info_outline,
                      color: Color(0xff007aff),
                    ),
                  ),
                  CupertinoListTile.notched(
                    title: Text(
                      "Support",
                      style: TextStyle(fontFamily: 'Open Sans'),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff007AFF),
                          borderRadius: BorderRadius.circular(7)),
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(
                        size: 20,
                        Icons.help_rounded,
                        color: Colors.white,
                      ),
                    ),
                    trailing: CupertinoListTileChevron(),
                    onTap: () {},
                  ),
                  CupertinoListTile.notched(
                    onTap: () async {
                      await Auth().signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => WidgetTree()),
                          (route) => false);
                    },
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          color: Color(0xffFF2B51),
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffFF2B51),
                          borderRadius: BorderRadius.circular(7)),
                      width: double.infinity,
                      height: double.infinity,
                      child: Icon(
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
      ]),
    );
  }
}
