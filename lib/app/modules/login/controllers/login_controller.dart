import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:motor_sport_easy/app/api_services/base_url.dart';
import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/custom_snackbar.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  Future<void> login() async {
    if (isLoading.value) return;

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      _showSnackbar("Input Error", "Enter both email and password");
      return;
    }

    isLoading.value = true;
    try {
      final fcmToken = (await _getFCMToken()) ?? "null";
      await _postCredential(fcmToken: fcmToken);
    } catch (_) {
      _showSnackbar("Login Error", "Unexpected error during login");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _postCredential({required String fcmToken}) async {
    final body = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "fcm_token": fcmToken,
    };

    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/user/login"),
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException("Connection timed out"),
          );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final token = decoded["access_token"]?["access_token"];
        if (token == null) {
          _showSnackbar("Error", "Token missing from server");
          return;
        }

        await SharedPrefHelper.saveToken(token);
        await SharedPrefHelper.saveEmail(emailController.text.trim());

        bool hasSubscription =
            await SharedPrefHelper.getSubscriptionState() ?? false;
        Get.offAllNamed(
          hasSubscription ? Routes.BOTTOM_NAVIGATION_BAR : Routes.SUBSCRIPTION,
        );
        return;
      }

      switch (response.statusCode) {
        case 400:
          _showSnackbar("Password Error", "Incorrect password");
          break;
        case 401:
          _showSnackbar("Authorization Error", "OTP not verified");
          break;
        case 404:
          _showSnackbar("Email Error", "Email not found");
          break;
        default:
          _showSnackbar("Server Error", "Status: ${response.statusCode}");
      }
    } on SocketException {
      _showSnackbar("Network Error", "No internet connection");
    } on TimeoutException catch (e) {
      _showSnackbar("Timeout", e.message ?? "Request took too long");
    } on FormatException {
      _showSnackbar("Response Error", "Invalid server data format");
    } catch (e) {
      _showSnackbar("Unexpected Error", "Something went wrong");
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;
      // FCM Token সংগ্রহ করুন
      final String fcmToken = (await _getFCMToken()) ?? "null";
      print('✅ FCM Token: $fcmToken');

      if (accessToken == null) {
        _showSnackbar("Error", "Failed to get Google access token");
        return false;
      }

      // ১. URL চেক করুন (ব্যাকএন্ড রাউট অনুযায়ী /google/login নিশ্চিত করুন)
      final uri = Uri.parse(
        "https://mse.motorsporteasy.cloud/auth/user/google/login",
      );

      // ২. বডি ডাটা যোগ করুন (Form-data হিসেবে)
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"access_token": accessToken, "fcm_token": fcmToken},
      );
      print('✅ Response: ${response.body}');
      print('✅ Response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token']?['access_token'];
        final email = data['access_token']?['user']?['uid'] ?? "";

        if (token == null) {
          _showSnackbar("Error", "Access token missing from server response");
          print("❌ Token is null in response");
          return false;
        }

        print('✅ Extracted Token: $token');
        await SharedPrefHelper.saveToken(token);
        if (email.isNotEmpty) {
          await SharedPrefHelper.saveEmail(email);
        }

        // সাবস্ক্রিপশন চেক করে নেভিগেট করুন
        bool hasSubscription =
            await SharedPrefHelper.getSubscriptionState() ?? false;
        print('✅ Has Subscription: $hasSubscription');
        print(
          '✅ Navigating to: ${hasSubscription ? Routes.BOTTOM_NAVIGATION_BAR : Routes.SUBSCRIPTION}',
        );

        Get.offAllNamed(
          hasSubscription ? Routes.BOTTOM_NAVIGATION_BAR : Routes.SUBSCRIPTION,
        );
        return true;
      } else {
        print(
          '❌ Google Login Failed: ${response.statusCode} - ${response.body}',
        );
        _showSnackbar("Google Login Failed", "Status: ${response.statusCode}");
        return false;
      }
    } catch (e, stack) {
      print('❌ Google Sign-In Exception: $e');
      print('❌ Stack Trace: $stack');
      _showSnackbar("Error", "Google Sign-In failed: $e");
      return false;
    }
  }

  Future<String?> _getFCMToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print("FCM Token Error: $e");
      return null;
    }
  }

  void _showSnackbar(String title, String message) {
    CustomSnackbar.show(title, message);
  }
}
