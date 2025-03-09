import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/screens/settings_profile_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/utils/fitbit_api_utils.dart';
import 'dart:convert';
import 'dart:math' show min;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> userData = {};
  late Future<void> _fetchUserDataFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    _fetchUserDataFuture = fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      userId = await Auth().getUserId();
      var data = await DatabaseUtils.getUserData(userId);
      setState(() {
        userData = data;
      });
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(onRefresh: fetchUserData);
        } else {
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f7),
            extendBodyBehindAppBar: true,
            body: RefreshIndicator(
              onRefresh: fetchUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                    image: AssetImage(
                                        'assets/icons/app_icon.png'))),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationUtils.push(
                                  context, SettingsProfileScreen());
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
                                      ? NetworkImage(userData['profileImgUrl'])
                                      : const AssetImage(
                                          'assets/images/default_user_profile_picture.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: const Text("daily reflection."),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final fitbitApiUtils = FitbitApiUtils();
                          final today = DateTime.now()
                              .toString()
                              .split(' ')[0]; // Format: YYYY-MM-DD

                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );

                          // Fetch only sleep data
                          final sleepData = await fitbitApiUtils
                              .fetchActivityData(userId, today);

                          // Dismiss loading indicator
                          Navigator.pop(context);
                          print(sleepData);
                          // Display the data
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Fitbit Sleep Data'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(sleepData != null
                                        ? jsonEncode(sleepData).substring(
                                                0,
                                                min(
                                                    jsonEncode(sleepData)
                                                        .length,
                                                    300)) +
                                            (jsonEncode(sleepData).length > 300
                                                ? '...'
                                                : '')
                                        : 'No sleep data available'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Fetch Sleep Data'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
