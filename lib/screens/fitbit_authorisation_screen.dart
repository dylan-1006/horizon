import 'package:flutter/material.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FitbitAuthorisationScreen extends StatefulWidget {
  const FitbitAuthorisationScreen({super.key});

  @override
  State<FitbitAuthorisationScreen> createState() =>
      _FitbitAuthorisationScreenState();
}

class _FitbitAuthorisationScreenState extends State<FitbitAuthorisationScreen> {
  final webController = WebViewController();
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  String? authorization_code;

  void initState() {
    super.initState();
    authoriseUser();
    webController.setJavaScriptMode(JavaScriptMode.unrestricted);
    webController.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          isLoading.value = true;
        },
        onPageFinished: (url) {
          isLoading.value = false;
        },
        onUrlChange: (change) async {
          if (change.url!.contains("horizon-0000.web.app/open")) {
            webController.loadRequest(Uri.parse('about:blank'));
            isLoading.value = true;

            webController.loadHtmlString('''
            <html>
             <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <body style="background-color: white; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; font-family: sans-serif;">
    <div style="position: absolute; top: 20px; left: 20px; font-size: 20px; color: black;">
       <p>Redirecting...</p>
      <p>Please do not close this window.</p>
    </div>
  </body>
</html>

            ''');

            await Future.delayed(const Duration(seconds: 10));

            _handleFinalRedirectUrl(
                "https://horizon-000.web.app/open/?code=$authorization_code");
          }
        },
      ),
    );
  }

  Future<void> _handleFinalRedirectUrl(String url) async {
    print(url);
  }

  Future<void> authoriseUser() async {
    print("authorise user Running");
    final url = Uri.parse(
        "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=23Q7ZV&redirect_uri=https://horizon-0000.web.app/open&scope=activity%20heartrate%20sleep&expires_in=604800");

    webController.loadRequest(
      url,
      method: LoadRequestMethod.post,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Confirm Exit",
                style: TextStyle(
                    color: Constants.primaryColor, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                  "Are you sure you want to go back? Any progress made for the authorisation will be cancelled."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _handleBackButtonPressed() async {
    bool shouldGoBack = await _showExitConfirmationDialog();
    if (shouldGoBack) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Container(
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackButtonPressed, // Show confirmation dialog
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webController),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, child) {
              return value
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: Constants.primaryColor),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
