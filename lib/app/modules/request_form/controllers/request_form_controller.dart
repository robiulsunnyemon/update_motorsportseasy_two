import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../api_services/base_url.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../../utils/custom_snackbar.dart';

class RequestFormController extends GetxController {
  final TextEditingController requestRaceNameController =
      TextEditingController();

  Future<void> submitRaceRequest() async {
    try {
      String? email = await SharedPrefHelper.getEmail();
      if (email != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/request/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_email": email.trim(),
            "request_details": requestRaceNameController.text,
          }),
        );

        if (response.statusCode == 201) {
          CustomSnackbar.show(
            'Success',
            'Race request submitted successfully!',
          );
        } else {
          CustomSnackbar.show(
            'Error',
            'Failed to submit request: ${response.body}',
          );
        }
      }
    } catch (e) {
      CustomSnackbar.show('Error', 'Failed to submit request: ${e.toString()}');
    }
  }
}
