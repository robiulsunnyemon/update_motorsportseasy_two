import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:motor_sport_easy/app/api_services/base_url.dart';
import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;
  var isGoogleLoading = false.obs;

  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _googleUser;

  @override
  void onInit() {
    super.onInit();
    _initializeGoogleSignIn();
  }

  void _initializeGoogleSignIn() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: '470378363502-vbpiu024cps4un92k6bk9sho59o8v0rd.apps.googleusercontent.com', // Add your Web Client ID
    );
    print("✅ Google Sign-In initialized");
  }

  /// --------------------------
  /// GOOGLE SIGN-IN
  /// --------------------------
  Future<void> signInWithGoogle() async {
    if (isGoogleLoading.value) return;

    isGoogleLoading.value = true;

    try {
      await _googleSignIn.signOut(); // ensure account picker shows
      _googleUser = await _googleSignIn.signIn();

      if (_googleUser == null) {
        _showSnackbar("Cancelled", "Google sign-in was cancelled");
        return;
      }

      final googleAuth = await _googleUser!.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        _showSnackbar("Error", "Failed to get Google ID token");
        return;
      }

      final fcmToken = (await _getFCMToken()) ?? "null";

      final success = await _postGoogleCredential(idToken: idToken, fcmToken: fcmToken);
      if (success) {
        _showSnackbar("Success", "Signed in with Google successfully!");
      }
    } catch (e, s) {
      print("❌ Google Sign-In Error: $e\n$s");
      _showSnackbar("Google Sign-In Error", "Failed to sign in with Google");
    } finally {
      isGoogleLoading.value = false;
    }
  }

  Future<bool> _postGoogleCredential({
    required String idToken,
    required String fcmToken,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/auth/user/google-login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_token": idToken,
          "fcm_token": fcmToken,
        }),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException("Connection timed out"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["access_token"]?["access_token"];
        if (token == null) {
          _showSnackbar("Error", "Access token missing from server");
          return false;
        }

        await SharedPrefHelper.saveToken(token);
        await SharedPrefHelper.saveEmail(data["email"] ?? _googleUser?.email ?? "");

        bool hasSubscription = await SharedPrefHelper.getSubscriptionState() ?? false;
        Get.offAllNamed(hasSubscription ? Routes.BOTTOM_NAVIGATION_BAR : Routes.SUBSCRIPTION);
        return true;
      } else if (response.statusCode == 422) {
        _showSnackbar("Validation Error", "Invalid Google credentials");
      } else {
        _showSnackbar("Server Error",
            "Status: ${response.statusCode}. ${response.body.isNotEmpty ? response.body : 'Please try again.'}");
      }
    } on SocketException {
      _showSnackbar("Network Error", "No internet connection");
    } on TimeoutException {
      _showSnackbar("Timeout", "Request timed out");
    } catch (e) {
      _showSnackbar("Unexpected Error", "Something went wrong");
      print("❌ Google API Error: $e");
    }
    return false;
  }

  /// --------------------------
  /// NORMAL EMAIL/PASSWORD LOGIN
  /// --------------------------
  Future<void> login() async {
    if (isLoading.value) return;

    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
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

        bool hasSubscription = await SharedPrefHelper.getSubscriptionState() ?? false;
        Get.offAllNamed(hasSubscription ? Routes.BOTTOM_NAVIGATION_BAR : Routes.SUBSCRIPTION);
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

  /// --------------------------
  /// FCM TOKEN
  /// --------------------------
  Future<String?> _getFCMToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print("FCM Token Error: $e");
      return null;
    }
  }

  /// --------------------------
  /// SAFE SNACKBAR
  /// --------------------------
  void _showSnackbar(String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    });
  }
}
