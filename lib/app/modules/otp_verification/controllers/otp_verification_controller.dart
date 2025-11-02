import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/api_services/contants.dart';
import 'package:motor_sport_easy/app/routes/app_pages.dart';


class OtpVerificationController extends GetxController {
  final otpController =TextEditingController();
  var isLoading=false.obs;

  Future<void> verifyOtp({required String email,required bool isResetPassword}) async {
    try{
      isLoading.value=true;
      update();
      final response= await http.post(
          Uri.parse("$baseUrl/auth/user/user_otp_verify"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email":email,
            "otp":otpController.text.trim()
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
        Get.snackbar("Success", "You Successfully varified your account");
        otpController.clear();
        if(isResetPassword){
          Get.offAllNamed(Routes.RESET_PASSWORD);
        }else{
          Get.offAllNamed(Routes.LOGIN);
        }
      }else if(response.statusCode==400){
        Get.snackbar("Error", "Your Otp is wrong");
      } else{
        Get.snackbar("Error", "Something went wrong");
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

  Future<void> resendOtp({required String email}) async {
    otpController.clear();
    try{
      final response= await http.post(
          Uri.parse("$baseUrl/auth/user/resend-otp"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email":email,
          })
      );
      if(response.statusCode==200){
        Get.snackbar("Success", "You Successfully resend your otp");
      }else{
        Get.snackbar("Error", "Something went wrong");
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
