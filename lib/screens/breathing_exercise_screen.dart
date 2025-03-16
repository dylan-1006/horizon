import 'package:flutter/material.dart';

import 'dart:async';

import 'package:horizon/constants.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

enum BreathingDuration {
  quick,
  medium,
  long,
}

enum BreathingPhase {
  inhale,
  hold,
  exhale,
}

class BreathingExerciseScreen extends StatefulWidget {
  final int totalBreaths;
  final Duration inhaleDuration;
  final Duration holdDuration;
  final Duration exhaleDuration;
  final Duration restDuration;

  const BreathingExerciseScreen({
    Key? key,
    this.totalBreaths = 5,
    this.inhaleDuration = const Duration(seconds: 4),
    this.holdDuration = const Duration(seconds: 2),
    this.exhaleDuration = const Duration(seconds: 4),
    this.restDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isBreathingActive = false;

  Timer? _instructionTimer;
  int _breathCount = 0;
  late BreathingDuration _selectedDuration;
  int _selected = 1;
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
    });
    _animationController.forward();
  }

  void _stopBreathing() {
    _animationController.reset();
    setState(() {
      _isBreathingActive = false;
      _currentPhase = BreathingPhase.inhale;
    });
  }

  @override
  void dispose() {
    _instructionTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDuration = BreathingDuration.medium;
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
        _instructionTimer = Timer(holdDuration, () {
          if (_isBreathingActive && mounted) {
            setState(() => _currentPhase = BreathingPhase.exhale);
            _animationController.reverse();
          }
        });
      } else if (status == AnimationStatus.dismissed) {
        _breathCount++;
        if (_breathCount >= totalBreaths) {
          _stopBreathing();
        } else {
          setState(() => _currentPhase = BreathingPhase.inhale);
          _instructionTimer = Timer(restDuration, () {
            if (_isBreathingActive && mounted) {
              _animationController.forward();
            }
          });
        }
      }
    });
  }

  int get totalBreaths {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return 5; // 1 minute total (12s per cycle * 5 = 60s)
      case BreathingDuration.medium:
        return 13; // 3 minutes total (14s per cycle * 13 = 182s)
      case BreathingDuration.long:
        return 17; // 5 minutes total (18s per cycle * 17 = 306s)
    }
  }

// Keep all existing duration getters the same:
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

  String get durationText {
    switch (_selectedDuration) {
      case BreathingDuration.quick:
        return "1 minute";
      case BreathingDuration.medium:
        return "3 minutes";
      case BreathingDuration.long:
        return "5 minutes";
    }
  }

  void _updateDuration(BreathingDuration newDuration) {
    if (_isBreathingActive)
      return; // Don't allow changes during active exercise

    setState(() {
      _selectedDuration = newDuration;
      // Update animation controller duration
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
                  margin: EdgeInsets.only(top: 40),
                  child: Text(
                    durationText, // Using the dynamic duration text
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      color: Constants.accentColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "Take a breath for "),
                          TextSpan(
                            text: "Balance",
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
                            // Outer circle
                            Container(
                              width: 240 * _animation.value,
                              height: 240 * _animation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffCCD0F5),
                              ),
                            ),
                            // Middle circle
                            Container(
                              width: 200 * _animation.value,
                              height: 200 * _animation.value,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff7984E4),
                              ),
                            ),
                            // Inner circle (button)
                            GestureDetector(
                              onTap: _toggleBreathing,
                              child: Container(
                                width: 160 * _animation.value,
                                height: 160 * _animation.value,
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
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                                    // child: Text(
                                    //   _buttonText,
                                    //   style: const TextStyle(
                                    //     fontFamily: 'Open Sans',
                                    //     color: Colors.white,
                                    //     fontSize: 20,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
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
                  margin: EdgeInsets.only(top: 40, bottom: 40),
                  child: SegmentedButtonSlide(
                    entries: const [
                      SegmentedButtonSlideEntry(
                        label: "Quick",
                      ),
                      SegmentedButtonSlideEntry(
                        label: "Medium",
                      ),
                      SegmentedButtonSlideEntry(
                        label: "Long",
                      ),
                    ],
                    selectedEntry: _selected,
                    onChange: (selected) {
                      setState(() {
                        _selected = selected;
                        // Update the breathing duration based on selection
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
                        // Update animation controller duration if needed
                        if (!_isBreathingActive) {
                          _animationController.duration = inhaleDuration;
                        }
                      });
                    },
                    colors: SegmentedButtonSlideColors(
                      barColor: Color(0xffF2F2F7),
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
                  margin: const EdgeInsets.only(bottom: 80),
                  child: Text(
                    "To lower stress levels, follow this breathing\nexercise and take slow, deep breaths",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
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
