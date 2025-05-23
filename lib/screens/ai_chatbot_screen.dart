import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:horizon/widget_tree.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AIChatbotScreen extends StatefulWidget {
  final String userReflection;

  const AIChatbotScreen({Key? key, required this.userReflection})
      : super(key: key);

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  String? aiResponse;
  bool isLoading = false;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add the initial user message
    _messages.add(ChatMessage(
      text: widget.userReflection,
      isUser: true,
    ));
    getAIResponse(widget.userReflection);

    // Add focus listener
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> getAIResponse(String userInput) async {
    setState(() => isLoading = true);
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    print("API Key: ${dotenv.env['OPENAI_API_KEY']}");

    // Build the message history for the API request
    List<Map<String, String>> messageHistory = [
      {
        "role": "system",
        "content":
            "You are a friendly and insightful AI assistant that helps users reflect on their thoughts and provide advice on how to improve their mood. Limit all your responses to 100 words. "
      },
    ];

    // Add previous messages to history
    for (var i = 0; i < _messages.length; i++) {
      ChatMessage message = _messages[i];
      messageHistory.add({
        "role": message.isUser ? "user" : "assistant",
        "content": message.text,
      });
    }

    // Add current user input if it's not already in the messages
    if (_messages.isEmpty || _messages.last.isUser == false) {
      messageHistory.add({"role": "user", "content": userInput});
    }

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}",
        },
        body: jsonEncode({
          // Ensure JSON encoding
          "model": "gpt-3.5-turbo",
          "messages": messageHistory,
          "temperature": 0.7, // Adjust creativity
          "max_tokens": 300,
          "top_p": 1.0,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final responseText = data['choices'][0]['message']['content'];

        setState(() {
          aiResponse = responseText;
          _messages.add(ChatMessage(
            text: responseText.toString(),
            isUser: false,
          ));
        });
        _scrollToBottom();
      } else {
        setState(() {
          aiResponse =
              'Error: Unable to fetch response. Status code: ${response.statusCode}';
          _messages.add(ChatMessage(
            text:
                'Error: Unable to fetch response. Status code: ${response.statusCode}',
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        aiResponse = 'Error: $e';
        _messages.add(ChatMessage(
          text: 'Error: $e',
          isUser: false,
        ));
      });
      print('Error: Unable to fetch response. Status code: $e');
      _scrollToBottom();
    }
    setState(() => isLoading = false);
  }

  void _handleSubmit() {
    if (_messageController.text.trim().isEmpty) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final message = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
      ));
      _messageController.clear();
    });

    _scrollToBottom();
    getAIResponse(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            NavigationUtils.pushAndRemoveUntil(context, const WidgetTree());
          },
        ),
        title: Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white),
              onPressed: () {
                _showOptionsMenu(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home_screen_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      );
                    }
                    return _messages[index];
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.25), // 25% opacity black
                                blurRadius: 4, // Blur: 4
                                offset: const Offset(0, 4), // X: 0, Y: 4
                                spreadRadius: 0, // Spread: 0
                              ),
                            ]),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Message',
                            hintStyle: TextStyle(color: Constants.accentColor),
                            border: InputBorder.none,
                            suffixIcon: _messageController.text.isNotEmpty
                                ? IconButton(
                                    icon:
                                        const Icon(Icons.arrow_forward_rounded),
                                    onPressed: _handleSubmit,
                                  )
                                : null,
                          ),
                          onSubmitted: (_) => _handleSubmit(),
                          onChanged: (text) => setState(() {}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.refresh, color: Color(0xff7984E4)),
                title: const Text('Start a new conversation'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _startNewConversation();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startNewConversation() {
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(
        text: "How can I help you today?",
        isUser: false,
      ));
    });
    _scrollToBottom();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final String id;

  ChatMessage({
    Key? key,
    required this.text,
    required this.isUser,
    String? id,
  })  : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.white : Color(0xff7984E4),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: isUser
                  ? Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )
                  : AIMessageText(
                      key: ValueKey('ai_msg_$id'),
                      text: text,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class AnimationStateManager {
  static final Set<String> _animatedMessagesKeys = {};

  static bool hasBeenAnimated(String key) {
    return _animatedMessagesKeys.contains(key);
  }

  static void markAsAnimated(String key) {
    _animatedMessagesKeys.add(key);
  }
}

class AIMessageText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;

  const AIMessageText({
    Key? key,
    required this.text,
    required this.textStyle,
  }) : super(key: key);

  @override
  State<AIMessageText> createState() => _AIMessageTextState();
}

class _AIMessageTextState extends State<AIMessageText> {
  String _displayedText = '';
  int _characterCount = 0;
  Timer? _timer;
  bool _isAnimationComplete = false;
  late String _animationKey;

  @override
  void initState() {
    super.initState();
    _animationKey = (widget.key as ValueKey).value;

    if (!AnimationStateManager.hasBeenAnimated(_animationKey)) {
      _startAnimation();
    } else {
      _displayedText = widget.text;
      _isAnimationComplete = true;
    }
  }

  void _startAnimation() {
    _timer?.cancel();

    _characterCount = 0;
    _displayedText = '';
    _isAnimationComplete = false;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_characterCount < widget.text.length) {
        setState(() {
          _characterCount++;
          _displayedText = widget.text.substring(0, _characterCount);
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isAnimationComplete = true;
          AnimationStateManager.markAsAnimated(_animationKey);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AnimationStateManager.hasBeenAnimated(_animationKey)) {
      return Text(
        widget.text,
        style: widget.textStyle,
      );
    }

    return Text(
      _isAnimationComplete ? widget.text : _displayedText,
      style: widget.textStyle,
    );
  }
}
