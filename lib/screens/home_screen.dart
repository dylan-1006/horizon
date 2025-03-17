import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/breathing_exercise_screen.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/screens/settings_profile_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/utils/fitbit_api_utils.dart';
import 'package:horizon/utils/prediction_utils.dart';
import 'package:horizon/widget_tree.dart';
import 'package:horizon/widgets/chart_section_widget.dart';
import 'package:horizon/widgets/breathing_exercise_widget.dart';
import 'dart:convert';
import 'dart:math' show min;

import 'package:horizon/widgets/last_anxiety_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Map<String, dynamic> userData = {};
  Map<String, Map<String, dynamic>?> fitBitData = {};
  late Future<void> _fetchUserDataFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    initNotifications();
    _fetchUserDataFuture = fetchAllData();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation!.requestNotificationsPermission();

    if (granted ?? false) {
      debugPrint("Notification permission granted");
    } else {
      debugPrint("Notification permission denied");
    }
  }

  Future<void> fetchAllData() async {
    try {
      userId = await Auth().getUserId();
      var data = await DatabaseUtils.getUserData(userId);

      final today = DateTime.now().toString().split(' ')[0];
      var newFitBitData = await FitbitApiUtils().fetchAllDataLast30Days(userId);

      // Update the state with setState to trigger a rebuild
      setState(() {
        fitBitData = {};
        userData = data;
        fitBitData = newFitBitData;
      });
      if (userData['isFitBitAuthorised'] == true) {
        startBackgroundDataFetch();
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> initNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        print('onDidReceiveNotificationResponse: $details');
        NavigationUtils.push(
            context, BreathingExerciseScreen(isTriggeredByPrediction: true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return ErrorScreen(onRefresh: fetchAllData);
        } else {
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f7),
            extendBodyBehindAppBar: true,
            body: RefreshIndicator(
              color: Constants.primaryColor,
              onRefresh: fetchAllData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/home_screen_background.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              margin: const EdgeInsets.only(left: 20, top: 20),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image:
                                      AssetImage('assets/icons/app_icon.png'),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigationUtils.push(
                                    context, SettingsProfileScreen());
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                margin:
                                    const EdgeInsets.only(right: 20, top: 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: userData['profileImgUrl'] != null
                                        ? NetworkImage(
                                            userData['profileImgUrl'])
                                        : const AssetImage(
                                            'assets/images/default_user_profile_picture.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 100),

                        // ElevatedButton(
                        //   onPressed: () async {
                        //     final fitbitApiUtils = FitbitApiUtils();
                        //     final yesterday = DateTime.now()
                        //         .subtract(Duration(days: 1))
                        //         .toString()
                        //         .split(' ')[0];
                        //     final today = DateTime.now()
                        //         .toString()
                        //         .split(' ')[0]; // Format: YYYY-MM-DD

                        //     // Show loading indicator
                        //     showDialog(
                        //       context: context,
                        //       barrierDismissible: false,
                        //       builder: (context) => const Center(
                        //           child: CircularProgressIndicator()),
                        //     );

                        //     // Fetch only sleep data
                        //     final sleepData =
                        //         await PredictionUtils().sendPredictionRequest([
                        //       60.75959491729736,
                        //       40.021232323232326,
                        //       27000321.036327794,
                        //       393.07152914671923,
                        //       56.625457617572515,
                        //       93.77640101379893,
                        //       9705,
                        //       178,
                        //       33,
                        //       33,
                        //       1196,
                        //       -1.547862704
                        //     ]);

                        //     Timer.periodic(Duration(seconds: 30),
                        //         (timer) async {
                        //       await PredictionUtils().sendPredictionRequest([
                        //         60.75959491729736,
                        //         40.021232323232326,
                        //         27000321.036327794,
                        //         393.07152914671923,
                        //         56.625457617572515,
                        //         93.77640101379893,
                        //         9705,
                        //         178,
                        //         33,
                        //         33,
                        //         1196,
                        //         -1.547862704
                        //       ]);
                        //     });
                        //     print(sleepData);
                        //     // Dismiss loading indicator
                        //     Navigator.pop(context);

                        //     // final processedData =
                        //     //     fitbitApiUtils.processAllData(sleepData);
                        //   },
                        //   child: const Text('Fetch Sleep Data'),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Row(
                            children: [
                              Expanded(child: BreathingExerciseWidget()),
                              const SizedBox(width: 10),
                              Expanded(child: LastAnxietyWidget()),
                            ],
                          ),
                        ),
                        ChartSection(fitbitData: fitBitData),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> startBackgroundDataFetch() async {
    print("Background fetch started");
    final fitbitApiUtils = FitbitApiUtils();
    final yesterday =
        DateTime.now().subtract(Duration(days: 1)).toString().split(' ')[0];
    final today = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD

    final allData = await fitbitApiUtils.fetchAllData(userId, yesterday);

    final processedData = fitbitApiUtils.processAllData(allData);
    print(processedData);

    List<num> extractedData =
        PredictionUtils.extractNumericValues(processedData);
    print(extractedData);
    final predictionResults =
        await PredictionUtils().sendPredictionRequest(extractedData);
    print(predictionResults);

    Timer.periodic(Duration(seconds: 300), (timer) async {
      final allData = await fitbitApiUtils.fetchAllData(userId, yesterday);

      final processedData = fitbitApiUtils.processAllData(allData);
      print(processedData);

      List<num> extractedData =
          PredictionUtils.extractNumericValues(processedData);
      print(extractedData);
      final predictionResults =
          await PredictionUtils().sendPredictionRequest(extractedData);
      print(predictionResults);
    });
  }
}
