// // import 'dart:async';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:motor_sport_easy/app/api_services/base_url.dart';
// // import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
// // import '../../../routes/app_pages.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// //
// // class LoginController extends GetxController {
// //   final emailController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   var isPasswordHidden = true.obs;
// //   var isLoading=false.obs;
// //
// //
// //
// //   Future<void> getAndSendFCMToken() async {
// //     try {
// //       isLoading.value=true;
// //       // Request notification permissions (important for iOS)
// //       await FirebaseMessaging.instance.requestPermission(
// //         alert: true,
// //         badge: true,
// //         sound: true,
// //       );
// //
// //       // Get the FCM token
// //       String? token = await FirebaseMessaging.instance.getToken();
// //
// //       if (token == null) {
// //         return;
// //       }else{
// //         postCredential(fcmToken: token);
// //       }
// //
// //     } catch (e) {
// //       Get.snackbar("Error", "Error getting FCM token: $e");
// //       throw Exception("Error getting FCM token: $e");
// //     }
// //   }
// //
// //   Future<void> postCredential({required String fcmToken}) async {
// //     isLoading.value=true;
// //     try{
// //       final response = await http.post(
// //         Uri.parse("$baseUrl/auth/user/login"),
// //         headers: {"Content-Type": "application/x-www-form-urlencoded"},
// //         body: {
// //           "email": emailController.text.trim(),
// //           "password": passwordController.text.trim(),
// //           "fcm_token":fcmToken.trim()
// //         },
// //       ).timeout(
// //         const Duration(seconds: 30),
// //         onTimeout: () {
// //           throw TimeoutException("Connection timed out. Please try again.");
// //         },
// //       );
// //       isLoading.value=false;
// //       if(response.statusCode==200){
// //         final decodedResponse=jsonDecode(response.body);
// //         final token=decodedResponse["access_token"]["access_token"];
// //         await SharedPrefHelper.saveToken(token);
// //         await SharedPrefHelper.saveEmail(emailController.text.trim());
// //         Get.offAllNamed(Routes.SUBSCRIPTION);
// //       }else if(response.statusCode==404){
// //         Get.snackbar("Email Error", "Your Email is Wrong");
// //       }else if(response.statusCode==400){
// //         Get.snackbar("Password Error", "Your Password is Wrong");
// //       }else if(response.statusCode==401){
// //         Get.snackbar("Authorization Error", "Your otp code is not varified");
// //       }
// //       else{
// //         Get.snackbar("Error", "Something went wrong");
// //       }
// //     }on SocketException {
// //       Get.snackbar("Network Error", "No internet connection. Please check your network.");
// //     } on TimeoutException catch (e) {
// //       Get.snackbar("Timeout", e.message ?? "The request took too long to complete.");
// //     } on FormatException {
// //       Get.snackbar("Response Error", "Invalid response format from the server.");
// //     } catch (e) {
// //       Get.snackbar("Unexpected Error", "Something went wrong. Please try again.");
// //     }
// //   }
// //
// //
// //   Future<void> login() async {
// //     try {
// //       bool? isAccepted = await SharedPrefHelper.getIsAcceptedNotification();
// //       if(isAccepted!=null){
// //         await getAndSendFCMToken();
// //       }else{
// //         postCredential(fcmToken: "null");
// //       }
// //         } catch (e) {
// //       throw Exception("Error getting FCM token: $e");
// //     }
// //   }
// //
// //
// //
// //
// //
// // }
//
//
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:motor_sport_easy/app/api_services/base_url.dart';
// import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
// import '../../../routes/app_pages.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class LoginController extends GetxController {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   var isPasswordHidden = true.obs;
//   var isLoading = false.obs;
//
//   // --------------------------
//   // LOGIN ENTRY POINT
//   // --------------------------
//   Future<void> login() async {
//     if (isLoading.value) return; // Prevent multiple taps
//     isLoading.value = true;
//
//     try {
//       bool? isAccepted = await SharedPrefHelper.getIsAcceptedNotification();
//       String fcmToken = "";
//
//       if (isAccepted == true) {
//         fcmToken = await _getFCMTokenWithRetry();
//       }
//
//       await _postCredential(fcmToken: fcmToken);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // --------------------------
//   // FCM TOKEN WITH RETRY
//   // --------------------------
//   Future<String> _getFCMTokenWithRetry({int retry = 3, int delaySeconds = 2}) async {
//     for (int i = 0; i < retry; i++) {
//       try {
//         await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
//         String? token = await FirebaseMessaging.instance.getToken();
//         if (token != null) return token;
//       } catch (_) {}
//       await Future.delayed(Duration(seconds: delaySeconds));
//     }
//     return ""; // return empty string if token not obtained
//   }
//
//   // --------------------------
//   // SEND LOGIN REQUEST
//   // --------------------------
//   Future<void> _postCredential({required String fcmToken}) async {
//     try {
//       final body = {
//         "email": emailController.text.trim(),
//         "password": passwordController.text.trim(),
//       };
//
//       // Only send FCM token if available
//       if (fcmToken.isNotEmpty) body["fcm_token"] = fcmToken;
//       if (fcmToken.isEmpty) body["fcm_token"] = "null";
//
//       final response = await http
//           .post(
//         Uri.parse("$baseUrl/auth/user/login"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: body,
//       );
//
//       print(response.statusCode);
//
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         final token = decoded?["access_token"]?["access_token"];
//
//         if (token == null) {
//           Get.snackbar("Error", "Token missing from server");
//           return;
//         }
//
//         await SharedPrefHelper.saveToken(token);
//         await SharedPrefHelper.saveEmail(emailController.text.trim());
//         if (await SharedPrefHelper.getSubscriptionState() == true) {
//           Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
//         }else{
//           // Get.offAllNamed(Routes.SUBSCRIPTION);
//           Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
//
//         }
//       }
//
//
//       // --------------------
//       // STATUS CODE HANDLING
//       // --------------------
//       switch (response.statusCode) {
//         case 400:
//           Get.snackbar("Password Error", "Your password is incorrect");
//           break;
//         case 401:
//           Get.snackbar("Authorization Error", "Your OTP is not verified");
//           break;
//         case 404:
//           Get.snackbar("Email Error", "Your email is incorrect");
//           break;
//       }
//     } on SocketException {
//       Get.snackbar("Network Error", "No internet connection");
//     } on TimeoutException {
//       Get.snackbar("Timeout", "The request took too long");
//     } on FormatException {
//       Get.snackbar("Response Error", "Invalid data from server");
//     } catch (e) {
//       Get.snackbar("Unexpected Error", "Please try again later");
//     }
//   }
// }



import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

// Your necessary files/classes
import 'package:motor_sport_easy/app/api_services/base_url.dart';
import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable Variables
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // --------------------------
  // 1. MAIN LOGIN FUNCTION (Entry Point)
  // --------------------------
  Future<void> login() async {
    // Prevent double taps
    if (isLoading.value) return;

    // Input validation
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar("Input Error", "Please enter both email and password.");
      return;
    }

    isLoading.value = true;
    try {
      // Always attempt to get FCM token
      String? token = await _getFCMToken();

      // Use the token or "null" string if retrieval fails
      String fcmTokenToSend = token ?? "null";

      // Post Credentials
      await _postCredential(fcmToken: fcmTokenToSend);

    } catch (e) {
      // Catch any unexpected errors during the process
      Get.snackbar("Login Error", "An unexpected issue occurred during login.");
    } finally {
      // Ensure loading state is turned off
      isLoading.value = false;
    }
  }

  // --------------------------
  // 2. FCM TOKEN RETRIEVAL
  // --------------------------
  Future<String?> _getFCMToken() async {
    try {
      // Request notification permissions (important for iOS)
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get the token
      return await FirebaseMessaging.instance.getToken();

    } catch (e) {
      print("FCM Token Error: $e");
      Get.snackbar("FCM Token Error", "Could not retrieve the notification token.");
      return null;
    }
  }

  // --------------------------
  // 3. POST CREDENTIALS (API Call)
  // --------------------------
  Future<void> _postCredential({required String fcmToken}) async {
    final Map<String, String> body = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "fcm_token": fcmToken, // Token or "null" is always sent
    };

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/user/login"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      ).timeout(
        const Duration(seconds: 30), // 30 seconds timeout
        onTimeout: () => throw TimeoutException("Connection timed out. Please try again."),
      );

      // --------------------
      // SUCCESS RESPONSE (200) HANDLING
      // --------------------
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final token = decoded?["access_token"]?["access_token"];

        if (token == null) {
          Get.snackbar("Error", "Access token is missing from the server response.");
          return;
        }

        // Save token and email
        await SharedPrefHelper.saveToken(token);
        await SharedPrefHelper.saveEmail(emailController.text.trim());

        // Check subscription status and navigate accordingly
        bool hasSubscription = await SharedPrefHelper.getSubscriptionState() ?? false;
        if (hasSubscription) {
          Get.offAllNamed(Routes.BOTTOM_NAVIGATION_BAR);
        } else {
          // Get.offAllNamed(Routes.SUBSCRIPTION);
          Get.offAllNamed(Routes.PROFILE);
        }
        return;
      }

      // --------------------
      // OTHER STATUS CODE HANDLING
      // --------------------
      switch (response.statusCode) {
        case 400:
          Get.snackbar("Password Error", "Your password is incorrect.");
          break;
        case 401:
          Get.snackbar("Authorization Error", "Your OTP code is not verified.");
          break;
        case 404:
          Get.snackbar("Email Error", "Your email address is incorrect.");
          break;
        default:
          Get.snackbar("Server Error", "Something went wrong. Status code: ${response.statusCode}");
      }

    } on SocketException {
      Get.snackbar("Network Error", "No internet connection. Please check your network.");
    } on TimeoutException catch (e) {
      Get.snackbar("Timeout", e.message ?? "The request took too long to complete.");
    } on FormatException {
      Get.snackbar("Response Error", "Invalid data format received from the server.");
    } catch (e) {
      // Handle all other exceptions
      Get.snackbar("Unexpected Error", "Something went wrong. Please try again later.");
    }
  }
}