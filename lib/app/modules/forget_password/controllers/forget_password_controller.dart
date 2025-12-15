import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/routes/app_pages.dart';

import '../../../api_services/base_url.dart';
class ForgetPasswordController extends GetxController {

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading=false.obs;

  Future<void> resendOtp() async {
    try{
      isLoading.value=true;
      update();
      final response= await http.post(
          Uri.parse("$baseUrl/auth/user/resend-otp"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email":emailController.text.trim(),
          })
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException("Connection timed out. Please try again.");
        },
      );
      isLoading.value=false;

      update();
      if(response.statusCode==200){
        Get.snackbar("Success", "You Successfully resend your otp. Please check your Email");
        Get.offAllNamed(Routes.OTP_VERIFICATION,arguments: {"email":emailController.text.trim(),"isResetPassword":true});
      }else if(response.statusCode==404){
        Get.snackbar("Error", "Your Email is not registered");
      }
      else{
        Get.snackbar("Error", "Something went wrong, Please try again");
      }
    }on SocketException {
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
