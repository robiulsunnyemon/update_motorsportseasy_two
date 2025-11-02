import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/api_services/contants.dart';
import '../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

import '../../../shared_pref_helper/shared_pref_helper.dart';

class SignupController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isConfirmHidden = true.obs;
  var isLoading=false.obs;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // void signUpWithEmail() async {
  //
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //   final fullName=fullNameController.text.trim();
  //
  //   try {
  //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     Get.snackbar("Success", "Account created for $email");
  //
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //       await user.updateDisplayName(fullName);
  //       await user.reload();
  //       Get.offAllNamed(Routes.LOGIN);
  //     }
  //
  //   } catch (e) {
  //     Get.snackbar("Signup Failed", e.toString());
  //   }
  // }

  Future<void> signup() async {
    try {
      isLoading.value=true;
      update();
      final email = emailController.text.trim();
      final fullName = fullNameController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (email.isEmpty || fullName.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar("Validation Error", "All fields are required");
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
      isLoading.value=false;
      update();
      if (response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Account created for $email.\nA 5-digit verification code has been sent to your email. Please verify your email.",
        );
        emailController.clear();
        fullNameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        await SharedPrefHelper.saveEmail(email);
        Get.offAllNamed(Routes.OTP_VERIFICATION,arguments: {"email":email,"isResetPassword":false});
      }else if (response.statusCode == 409) {
        Get.snackbar("Signup Failed", "This email is already registered.");
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
