import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../api_services/contants.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import 'package:http/http.dart' as http;


class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isLoading = false.obs;

  Future<void> resetPassword() async {
    try {
      isLoading.value=true;
      update();
      final email = SharedPrefHelper.getEmail();
      final confirmPassword = confirmPasswordController.text.trim();


      final uri = Uri.parse("$baseUrl/auth/user/reset_password");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "new_password": confirmPassword
        }),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException("Connection timed out. Please try again.");
        },
      );
      isLoading.value=false;
      update();
      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Password reset successfully. Please login with the new password.",
        );
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAllNamed(Routes.LOGIN);


      }else if (response.statusCode == 404) {
        Get.snackbar("Signup Failed", "You are not registered. Please signup first");
      }else if (response.statusCode == 400) {
        Get.snackbar("Signup Failed", "You are not varified");
      } else if (response.statusCode == 500) {
        Get.snackbar("Server Error", "Something went wrong on the server. Please try later.");

      } else {
        Get.snackbar("Error", "Unexpected error occurred. Code: ${response.statusCode}");
      }
    } on SocketException {
      Get.snackbar("Network Error", "No internet connection. Please check your network.");
    } on TimeoutException catch (e) {
      Get.snackbar("Timeout", e.message ?? "The request took too long to complete.");
    } on FormatException {
      Get.snackbar("Response Error", "Invalid response format from the server.");
    } catch (e) {
      Get.snackbar("Unexpected Error", "Something went wrong. Please try again.");
    }
  }

}
