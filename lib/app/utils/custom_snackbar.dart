import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show(String title, String message, {Color? backgroundColor}) {
    final Color bgColor =
        backgroundColor ?? (title == "Success" ? Colors.green : Colors.red);

    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bgColor,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      // Fallback
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
