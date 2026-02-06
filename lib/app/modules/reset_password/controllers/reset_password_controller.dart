import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../api_services/base_url.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import '../../../utils/custom_snackbar.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isLoading = false.obs;

  Future<void> resetPassword() async {
    try {
      isLoading.value = true;
      update();
      final email = await SharedPrefHelper.getEmail();
      final confirmPassword = confirmPasswordController.text.trim();

      final uri = Uri.parse("$baseUrl/auth/user/reset_password");

      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "new_password": confirmPassword}),
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
          "Password reset successfully. Please login with the new password.",
        );
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAllNamed(Routes.LOGIN);
      } else if (response.statusCode == 404) {
        CustomSnackbar.show(
          "Signup Failed",
          "You are not registered. Please signup first",
        );
      } else if (response.statusCode == 400) {
        CustomSnackbar.show("Signup Failed", "You are not varified");
      } else if (response.statusCode == 500) {
        CustomSnackbar.show(
          "Server Error",
          "Something went wrong on the server. Please try later.",
        );
      } else {
        CustomSnackbar.show(
          "Error",
          "Unexpected error occurred. Code: ${response.statusCode}",
        );
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
