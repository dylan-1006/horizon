import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/home_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/screens/settings_profile_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class FitbitAuthorisationScreen extends StatefulWidget {
  const FitbitAuthorisationScreen({super.key});

  @override
  State<FitbitAuthorisationScreen> createState() =>
      _FitbitAuthorisationScreenState();
}

class _FitbitAuthorisationScreenState extends State<FitbitAuthorisationScreen> {
  Map<String, dynamic> userData = {};
  late String userId;
  final webController = WebViewController();
  final cookieManager = WebViewCookieManager();
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  String? authorizationCode;
  late String codeVerifier;
  late String codeChallenge;

  final String clientId = "23Q7ZV";
  final String redirectUri = "https://horizon-0000.web.app/open";
  final String tokenUrl = "https://api.fitbit.com/oauth2/token";
  Future<void> _initializeWebView() async {
    await cookieManager.clearCookies(); 
    await webController.clearCache(); 

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
          if (change.url!.contains("$redirectUri?code=")) {
            final Uri uri = Uri.parse(change.url!);
            authorizationCode = uri.queryParameters['code'];
            webController.loadRequest(Uri.parse('about:blank'));

            if (authorizationCode != null) {
              await exchangeAuthorizationCodeForToken(authorizationCode!);
              isLoading.value = true;
            }
          } else if (change.url!.contains("$redirectUri?error_description")) {
            NavigationUtils.push(context, ErrorScreen(onRefresh: () {
              NavigationUtils.pushAndRemoveUntil(context, HomeScreen());
            }));
          }
        },
      ),
    );

    authoriseUser();
  }

  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> exchangeAuthorizationCodeForToken(String authCode) async {
    String clientSecret = "1190125792b923fdf6d03f2dc53d5c6c";
    String credentials = "$clientId:$clientSecret";
    String encodedCredentials = base64Encode(utf8.encode(credentials));
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        "Authorization": "Basic $encodedCredentials",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "client_id": clientId,
        "code": authCode,
        "code_verifier": codeVerifier,
        "grant_type": "authorization_code",
        "redirect_uri": redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String accessToken = responseData["access_token"];
      String refreshToken = responseData["refresh_token"];
      print(responseData);

      print("Access Token: $accessToken");
      print("Refresh Token: $refreshToken");
      await fetchUserData();
      await DatabaseUtils.updateDocument("users", userId, {
        "isFitBitAuthorised": true,
        "fitbitAccessToken": accessToken,
        "fitbitRefreshToken": refreshToken,
        "tokenUpdatedAt": FieldValue.serverTimestamp(),
      });

      _handleReturnToProfileScreen();
    } else {
      NavigationUtils.push(context, ErrorScreen(onRefresh: () {
        NavigationUtils.pushAndRemoveUntil(context, HomeScreen());
      }));
    }
  }

  Future<void> fetchUserData() async {
    userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);
  }

  void generateCodeVerifierAndChallenge() {
    final Random random = Random.secure();
    final List<int> verifierBytes =
        List<int>.generate(64, (_) => random.nextInt(256));
    codeVerifier = base64UrlEncode(verifierBytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');

    final List<int> challengeBytes =
        sha256.convert(utf8.encode(codeVerifier)).bytes;
    codeChallenge = base64UrlEncode(challengeBytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  Future<void> _handleFinalRedirectUrl(String url) async {
    print("this is the url from handle final redirect url " + url);
  }

  void authoriseUser() async {
    print("authorise user Running");
    generateCodeVerifierAndChallenge();

    final String authUrl = "https://www.fitbit.com/oauth2/authorize"
        "?client_id=$clientId"
        "&response_type=code"
        "&redirect_uri=$redirectUri"
        "&scope=activity heartrate sleep"
        "&code_challenge=$codeChallenge"
        "&code_challenge_method=S256";

    print("this is the authUrl" + authUrl);
    final url = Uri.parse(authUrl);

    webController.loadRequest(url);
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

  Future<bool> _showAuthorisationSuccessfulDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Authorisation Successful",
                style: TextStyle(
                    color: Constants.primaryColor, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                  "Your Fitbit account has been successfully authorized."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Constants.primaryColor),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _handleReturnToProfileScreen() async {
    bool shouldGoBack = await _showAuthorisationSuccessfulDialog();
    if (shouldGoBack) {
      NavigationUtils.popUntil(context, 2);
    }
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
        backgroundColor: Colors.white,
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
              return value ? LoadingScreen() : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
