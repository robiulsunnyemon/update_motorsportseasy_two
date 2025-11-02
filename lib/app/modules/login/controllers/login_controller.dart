import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/api_services/contants.dart';
import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
import '../../../routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordHidden = true.obs;
  var isLoading=false.obs;



  Future<void> getAndSendFCMToken() async {
    try {
      isLoading.value=true;
      // Request notification permissions (important for iOS)
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get the FCM token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token == null) {
        return;
      }else{
        postCredential(fcmToken: token);
      }

    } catch (e) {
      Get.snackbar("Error", "Error getting FCM token: $e");
      throw Exception("Error getting FCM token: $e");
    }
  }

  Future<void> postCredential({required String fcmToken}) async {
    isLoading.value=true;
    try{
      final response = await http.post(
        Uri.parse("$baseUrl/auth/user/login"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "fcm_token":fcmToken.trim()
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException("Connection timed out. Please try again.");
        },
      );
      isLoading.value=false;
      if(response.statusCode==200){
        final decodedResponse=jsonDecode(response.body);
        final token=decodedResponse["access_token"]["access_token"];
        await SharedPrefHelper.saveToken(token);
        await SharedPrefHelper.saveEmail(emailController.text.trim());
        Get.offAllNamed(Routes.SUBSCRIPTION);
      }else if(response.statusCode==404){
        Get.snackbar("Email Error", "Your Email is Wrong");
      }else if(response.statusCode==400){
        Get.snackbar("Password Error", "Your Password is Wrong");
      }else if(response.statusCode==401){
        Get.snackbar("Authorization Error", "Your otp code is not varified");
      }
      else{
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


  Future<void> login() async {
    try {
      bool? isAccepted = await SharedPrefHelper.getIsAcceptedNotification();
      if(isAccepted!=null){
        await getAndSendFCMToken();
      }else{
        postCredential(fcmToken: "null");
      }
        } catch (e) {
      throw Exception("Error getting FCM token: $e");
    }
  }





}