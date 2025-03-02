import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/screens/settings_profile_screen.dart';
import 'package:horizon/utils/database_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> userData = {};
  Future<void> fetchUserData() async {
    String userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else {
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f7),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Container(
                height: 1100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/home_screen_background.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          margin: const EdgeInsets.only(left: 20, top: 85),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image:
                                      AssetImage('assets/icons/app_icon.png'))),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsProfileScreen(
                                          userData: userData,
                                        )));
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.only(right: 20, top: 95),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: userData['profileImgUrl'] != null
                                        ? NetworkImage(
                                            userData['profileImgUrl'])
                                        : const AssetImage(
                                            'assets/images/default_user_profile_picture.jpg'))),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: const Text("daily reflection."),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
