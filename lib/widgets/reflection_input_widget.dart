import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/ai_chatbot_screen.dart';
import 'package:horizon/utils/navigation_utils.dart';

class ReflectionInputWidget extends StatefulWidget {
  const ReflectionInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ReflectionInputWidget> createState() => _ReflectionInputWidgetState();
}

class _ReflectionInputWidgetState extends State<ReflectionInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String userReflection = '';

  @override
  void initState() {
    super.initState();
    // Add a listener to clear text when returning from AI chatbot screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isNotEmpty) {
      userReflection = _controller.text;
      _controller.clear();

      NavigationUtils.push(
          context, AIChatbotScreen(userReflection: userReflection));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25), // 25% opacity black
                blurRadius: 4, // Blur: 4
                offset: const Offset(0, 4), // X: 0, Y: 4
                spreadRadius: 0, // Spread: 0
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(
                color: Constants.accentColor,
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: _controller.text.trim().isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded),
                      onPressed: _handleSubmit,
                    )
                  : null,
            ),
            textInputAction: TextInputAction.go,
            onSubmitted: (_) => _handleSubmit(),
            onChanged: (text) {
              setState(() {
                // The state update will trigger a rebuild and update the suffixIcon visibility
                // based on the _controller.text.isNotEmpty condition
              });
            },
          ),
        ),
      ),
    );
  }
}
