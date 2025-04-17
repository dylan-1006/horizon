import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'dart:async';
import 'package:horizon/constants.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

enum BreathingDuration { quick, medium, long }

enum BreathingPhase { inhale, hold, exhale }

class BreathingExerciseScreen extends StatefulWidget {
  final int totalBreaths;
  final Duration inhaleDuration;
  final Duration holdDuration;
  final Duration exhaleDuration;
  final Duration restDuration;
  final bool isTriggeredByPrediction;

  const BreathingExerciseScreen({
    Key? key,
    this.totalBreaths = 5,
    this.inhaleDuration = const Duration(seconds: 4),
    this.holdDuration = const Duration(seconds: 2),
    this.exhaleDuration = const Duration(seconds: 4),
    this.restDuration = const Duration(seconds: 2),
    required this.isTriggeredByPrediction,
  }) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late String userId;
  Map<String, dynamic> userData = {};
  late double modelNotificationSensitivity;

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isBreathingActive = false;
  Timer? _instructionTimer, _countdownTimer;
  int _breathCount = 0;
  int _remainingTime = 0;
  late BreathingDuration _selectedDuration;
  int _selected = 0;
  BreathingPhase _currentPhase = BreathingPhase.inhale;

  void _toggleBreathing() {
    if (_isBreathingActive) {
      _stopBreathing();
    } else {
      _startBreathing();
    }
  }

  void _startBreathing() {
    setState(() {
      _isBreathingActive = true;
      _currentPhase = BreathingPhase.inhale;
      switch (_selectedDuration) {
        case BreathingDuration.quick:
          _remainingTime = 60; // 1 minute
          break;
        case BreathingDuration.medium:
          _remainingTime = 180; // 3 minutes
          break;
        case BreathingDuration.long:
          _remainingTime = 300; // 5 minutes
          break;
      }
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime > 0)
          _remainingTime--;
        else
          _stopBreathing();
      });
    });

    _animationController.forward();
  }

  void _stopBreathing() {
    _countdownTimer?.cancel();
    _animationController.reset();
    setState(() {
      _isBreathingActive = false;
      _currentPhase = BreathingPhase.inhale;
      _remainingTime = 0;
    });
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    _countdownTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _selectedDuration = BreathingDuration.quick;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.inhaleDuration,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (!mounted) return;

      if (status == AnimationStatus.completed) {
        setState(() => _currentPhase = BreathingPhase.hold);
        _instructionTimer = Timer(widget.holdDuration, () {
          if (_isBreathingActive && mounted) {
            setState(() => _currentPhase = BreathingPhase.exhale);
            _animationController.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        _breathCount++;
        if (_breathCount >= widget.totalBreaths) {
          _stopBreathing();
        } else {
          setState(() => _currentPhase = BreathingPhase.inhale);
          _instructionTimer = Timer(widget.restDuration, () {
            if (_isBreathingActive && mounted) {
              _animationController.forward();
            }
          });
        }
      }
    });

    // Show anxiety confirmation dialog if triggered by prediction
    if (widget.isTriggeredByPrediction) {
      // Use a post-frame callback to ensure the screen is built before showing dialog
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await fetchUserData();
          if (mounted) {
            _showAnxietyConfirmationDialog();
          }
        }
      });
    }
  }

  Future<void> fetchUserData() async {
    userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);
    modelNotificationSensitivity =
        userData['modelNotificationSensitivity'] ?? 0.8;
  }

  Future<void> updateModelNotificationSensitivity() async {
    await DatabaseUtils.updateDocument("users", userId,
        {"modelNotificationSensitivity": modelNotificationSensitivity + 0.02});
  }

  Future<void> updateAnxietyLastTriggerTime() async {
    await DatabaseUtils.updateDocument("users", userId,
        {"anxietyLastTriggerTime": FieldValue.serverTimestamp()});
  }

  void _showAnxietyConfirmationDialog() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Anxiety Detected",
            style: TextStyle(
              color: Constants.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              "Your anxiety levels seem high. Would you like to continue with the breathing exercise?"),
          actions: [
            TextButton(
              onPressed: () async {
                await updateModelNotificationSensitivity();
                if (!mounted) return;

                //Navigator.of(context).pop(); // Close the first dialog

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Model Adjusted",
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                          "Okay the prediction model will be adjusted accordingly."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                "False Alarm",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await updateAnxietyLastTriggerTime();
                Navigator.of(context)
                    .pop(); // Just close the dialog and continue
              },
              child: const Text(
                "Yes, continue",
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  int get totalBreaths {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return 5;
      case BreathingDuration.medium:
        return 13;
      case BreathingDuration.long:
        return 17;
    }
  }

  Duration get inhaleDuration {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return const Duration(seconds: 4);
      case BreathingDuration.medium:
        return const Duration(seconds: 4);
      case BreathingDuration.long:
        return const Duration(seconds: 5);
    }
  }

  Duration get holdDuration {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return const Duration(seconds: 2);
      case BreathingDuration.medium:
        return const Duration(seconds: 4);
      case BreathingDuration.long:
        return const Duration(seconds: 5);
    }
  }

  Duration get exhaleDuration {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return const Duration(seconds: 4);
      case BreathingDuration.medium:
        return const Duration(seconds: 4);
      case BreathingDuration.long:
        return const Duration(seconds: 5);
    }
  }

  Duration get restDuration {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return const Duration(seconds: 2);
      case BreathingDuration.medium:
        return const Duration(seconds: 2);
      case BreathingDuration.long:
        return const Duration(seconds: 3);
    }
  }

  String _formatDuration(int seconds) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void _updateDuration(BreathingDuration newDuration) {
    if (_isBreathingActive) return;
    setState(() {
      _selectedDuration = newDuration;
      _animationController.duration = inhaleDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffF2F2F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/breathing_exercise_screen_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    _isBreathingActive
                        ? _formatDuration(_remainingTime)
                        : _selectedDuration == BreathingDuration.quick
                            ? "1 minute"
                            : _selectedDuration == BreathingDuration.medium
                                ? "3 minutes"
                                : "5 minutes",
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      color: Constants.accentColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                              text: widget.isTriggeredByPrediction
                                  ? "Breathe to reduce "
                                  : "Take a breath for "),
                          TextSpan(
                            text: widget.isTriggeredByPrediction
                                ? "Anxiety"
                                : "Balance",
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 210 * _animation.value,
                              height: 210 * _animation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffCCD0F5),
                              ),
                            ),
                            Container(
                              width: 170 * _animation.value,
                              height: 170 * _animation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff7984E4),
                              ),
                            ),
                            GestureDetector(
                              onTap: _toggleBreathing,
                              child: Container(
                                width: 130 * _animation.value,
                                height: 130 * _animation.value,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    _isBreathingActive
                                        ? _currentPhase
                                            .toString()
                                            .split('.')
                                            .last
                                            .toUpperCase()
                                        : "START",
                                    style: const TextStyle(
                                      fontFamily: 'Open Sans',
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 50),
                  child: SegmentedButtonSlide(
                    entries: const [
                      SegmentedButtonSlideEntry(label: "Quick"),
                      SegmentedButtonSlideEntry(label: "Medium"),
                      SegmentedButtonSlideEntry(label: "Long"),
                    ],
                    selectedEntry: _selected,
                    onChange: (selected) {
                      setState(() {
                        _selected = selected;
                        switch (selected) {
                          case 0:
                            _selectedDuration = BreathingDuration.quick;
                            break;
                          case 1:
                            _selectedDuration = BreathingDuration.medium;
                            break;
                          case 2:
                            _selectedDuration = BreathingDuration.long;
                            break;
                        }
                        if (!_isBreathingActive) {
                          _animationController.duration = inhaleDuration;
                        }
                      });
                    },
                    colors: SegmentedButtonSlideColors(
                      barColor: const Color(0xffF2F2F7),
                      backgroundSelectedColor: Constants.primaryColor,
                    ),
                    animationDuration: const Duration(milliseconds: 350),
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    height: 40,
                    borderRadius: BorderRadius.circular(12),
                    selectedTextStyle: const TextStyle(
                      fontFamily: 'Open Sans',
                      color: Colors.white,
                    ),
                    unselectedTextStyle: TextStyle(
                      color: Constants.accentColor,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Text(
                    "To lower stress levels, follow this breathing\nexercise and take slow, deep breaths",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 14,
                      color: Constants.accentColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
