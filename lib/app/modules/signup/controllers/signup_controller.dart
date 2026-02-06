import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/api_services/base_url.dart';
import '../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../../utils/custom_snackbar.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isLoading = false.obs;

  Future<void> signup() async {
    try {
      isLoading.value = true;
      update();

      final email = emailController.text.trim();
      final fullName = fullNameController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (email.isEmpty || fullName.isEmpty || confirmPassword.isEmpty) {
        _showSimpleSnackbar("Validation Error", "All fields are required");
        return;
      }

      final uri = Uri.parse("$baseUrl/auth/user/signup");

      final response = await http
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "first_name": fullName,
              "email": email,
              "role": "customer",
              "password": confirmPassword,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("Connection timed out. Please try again.");
            },
          );

      isLoading.value = false;
      update();

      if (response.statusCode == 201) {
        // Success
        await SharedPrefHelper.saveEmail(email);

        // Show success message first
        _showSimpleSnackbar(
          "Success",
          "Account created successfully! Check your email for verification code.",
        );
        Get.offAllNamed(
          Routes.OTP_VERIFICATION,
          arguments: {"email": email, "isResetPassword": false},
        );
      } else {
        // Error - parse and show message
        final responseJson = jsonDecode(response.body);
        final errorMessage =
            responseJson['detail'] ??
            responseJson['message'] ??
            "Signup failed (Status: ${response.statusCode})";

        _showSimpleSnackbar("Signup Failed", errorMessage.toString());
      }
    } catch (e) {
      isLoading.value = false;
      update();
      print("Signup error: $e");
      _showSimpleSnackbar("Error", e.toString());
    }
  }

  void _showSimpleSnackbar(String title, String message) {
    CustomSnackbar.show(title, message);
  }
}
