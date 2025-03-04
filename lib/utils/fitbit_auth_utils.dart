import 'dart:convert';
import 'package:horizon/utils/database_utils.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FitbitAuthUtils {
  static const String clientId = "23Q7ZV";
  static const String clientSecret = "1190125792b923fdf6d03f2dc53d5c6c";
  static const String tokenUrl = "https://api.fitbit.com/oauth2/token";

  static Future<DateTime> getFirebaseTime() async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('timestamps')
          .add({'timestamp': FieldValue.serverTimestamp()});

      DocumentSnapshot snapshot = await docRef.get();
      Timestamp timestamp = snapshot.get('timestamp');

      await docRef.delete();

      return timestamp.toDate();
    } catch (e) {
      print('Error getting Firebase server time: $e');
      return DateTime.now();
    }
  }

  static Future<void> refreshAccessToken(String userId) async {
    try {
      Map<String, dynamic> userData = await DatabaseUtils.getUserData(userId);

      String? refreshToken = userData["fitbitRefreshToken"];
      var tokenUpdatedAt = userData["tokenUpdatedAt"];
      DateTime updatedTime = tokenUpdatedAt.toDate().toUtc();

      DateTime expiryTime = userData.containsKey("fitbitTokenExpiry")
          ? (userData["fitbitTokenExpiry"].toDate().toUtc())
          : updatedTime;
      DateTime currentTime = await getFirebaseTime();

      if (currentTime.isBefore(expiryTime)) {
        print("Token is still valid. No need to refresh.");
        print(DateTime.now());
        print(expiryTime);
        return userData["fitbitAccessToken"];
      }

      String basicAuth =
          "Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}";

      var response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          "Authorization": basicAuth,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "grant_type": "refresh_token",
          "refresh_token": refreshToken,
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        var data = jsonDecode(response.body);
        String newAccessToken = data["access_token"];
        String newRefreshToken = data["refresh_token"];
        int expiresIn = data["expires_in"];

        DateTime newExpiryTime = currentTime.add(Duration(seconds: expiresIn));

        await DatabaseUtils.updateDocument("users", userId, {
          "fitbitAccessToken": newAccessToken,
          "fitbitRefreshToken": newRefreshToken,
          "tokenUpdatedAt": FieldValue.serverTimestamp(),
          'fitbitTokenExpiry': newExpiryTime,
        });

        print("Access token refreshed successfully!");
      } else {
        print("Failed to refresh access token: ${response.body}");
      }
    } catch (e) {
      print("Error refreshing access token: $e");
    }
  }
}
