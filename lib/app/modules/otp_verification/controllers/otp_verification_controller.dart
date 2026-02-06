import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/api_services/base_url.dart';
import 'package:motor_sport_easy/app/routes/app_pages.dart';
import '../../../utils/custom_snackbar.dart';

class OtpVerificationController extends GetxController {
  final otpController = TextEditingController();
  var isLoading = false.obs;

  // -----------------------------
  // VERIFY OTP
  // -----------------------------
  Future<void> verifyOtp({
    required String email,
    required bool isResetPassword,
  }) async {
    if (otpController.text.trim().isEmpty) {
      CustomSnackbar.show("Error", "Please enter OTP");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/user/user_otp_verify"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email,
              "otp": otpController.text.trim(),
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw TimeoutException("Connection timed out. Try again."),
          );

      isLoading.value = false;

      if (response.statusCode == 200) {
        CustomSnackbar.show(
          "Success",
          "Your account has been successfully verified",
        );

        otpController.clear();

        if (isResetPassword) {
          Get.offAllNamed(Routes.RESET_PASSWORD);
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      } else if (response.statusCode == 400) {
        CustomSnackbar.show("Invalid OTP", "The OTP you entered is incorrect.");
      } else {
        CustomSnackbar.show("Error", "Something went wrong. Try again.");
      }
    } on SocketException {
      isLoading.value = false;
      CustomSnackbar.show(
        "Network Error",
        "Please check your internet connection.",
      );
    } on TimeoutException catch (e) {
      isLoading.value = false;
      CustomSnackbar.show("Timeout", e.message ?? "The request took too long.");
    } on FormatException {
      isLoading.value = false;
      CustomSnackbar.show("Response Error", "Invalid response from server.");
    } catch (e) {
      isLoading.value = false;
      CustomSnackbar.show("Unexpected Error", "Please try again later.");
    }
  }

  // -----------------------------
  // RESEND OTP
  // -----------------------------
  Future<void> resendOtp({required String email}) async {
    otpController.clear();

    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/user/resend-otp"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () =>
                throw TimeoutException("Connection timed out. Try again."),
          );

      if (response.statusCode == 200) {
        CustomSnackbar.show("Success", "OTP sent successfully");
      } else {
        CustomSnackbar.show("Error", "Something went wrong. Try again.");
      }
    } on SocketException {
      CustomSnackbar.show(
        "Network Error",
        "Please check your internet connection.",
      );
    } on TimeoutException catch (e) {
      CustomSnackbar.show("Timeout", e.message ?? "The request took too long.");
    } on FormatException {
      CustomSnackbar.show("Response Error", "Invalid response from server.");
    } catch (e) {
      CustomSnackbar.show("Unexpected Error", "Please try again later.");
    }
  }
}
