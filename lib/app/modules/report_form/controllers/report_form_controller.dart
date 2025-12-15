import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api_services/base_url.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import 'package:http/http.dart' as http;




class ReportFormController extends GetxController {

  final TextEditingController reportMessageController = TextEditingController();

  Future<void> submitReport() async {
    try {
      String? email =await SharedPrefHelper.getEmail();
      if (email != null) {

        final response = await http.post(
          Uri.parse("$baseUrl/report/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_email": email.trim(),
            "report_details": reportMessageController.text
          }),
        );

        if(response.statusCode==201){
          Get.snackbar('Success', 'Your report submitted successfully!');
        }else{
          Get.snackbar('Error', 'Failed to submit report: ${response.body}');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit report: ${e.toString()}');
    }
  }


}
