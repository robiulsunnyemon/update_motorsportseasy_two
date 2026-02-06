import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/routes/app_pages.dart';

import '../../../api_services/base_url.dart';
import '../../../utils/custom_snackbar.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      update();
      final response = await http
          .post(
            Uri.parse("$baseUrl/auth/user/resend-otp"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": emailController.text.trim()}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("Connection timed out. Please try again.");
            },
          );
      isLoading.value = false;

      update();
      if (response.statusCode == 200) {
        CustomSnackbar.show(
          "Success",
          "You Successfully resend your otp. Please check your Email",
        );
        Get.offAllNamed(
          Routes.OTP_VERIFICATION,
          arguments: {
            "email": emailController.text.trim(),
            "isResetPassword": true,
          },
        );
      } else if (response.statusCode == 404) {
        CustomSnackbar.show("Error", "Your Email is not registered");
      } else {
        CustomSnackbar.show("Error", "Something went wrong, Please try again");
      }
    } on SocketException {
      CustomSnackbar.show(
        "Network Error",
        "No internet connection. Please check your network.",
      );
    } on TimeoutException catch (e) {
      CustomSnackbar.show(
        "Timeout",
        e.message ?? "The request took too long to complete.",
      );
    } on FormatException {
      CustomSnackbar.show(
        "Response Error",
        "Invalid response format from the server.",
      );
    } catch (e) {
      CustomSnackbar.show(
        "Unexpected Error",
        "Something went wrong. Please try again.",
      );
    }
  }
}
