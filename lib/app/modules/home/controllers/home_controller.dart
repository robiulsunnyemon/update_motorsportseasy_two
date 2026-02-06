import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/api_services/base_url.dart';
import '../../../api_services/race_api_services/race_api_services.dart';
import '../../../data/model/race_api_model.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:http/http.dart' as http;
import '../../../utils/custom_snackbar.dart';

class HomeController extends GetxController {
  final TextEditingController requestRaceNameController =
      TextEditingController();
  final TextEditingController reportMessageController = TextEditingController();

  Future<void> showRequestDialog(BuildContext context) async {
    final isTermsAccepted = await SharedPrefHelper.getIsTermsAccepted();
    if (context.mounted) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Request',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            content: SizedBox(height: 10, width: 300),
            actions: <Widget>[
              CustomElevatedButton(
                level: "Request a racing series",
                onTap: () {
                  Get.back();
                  showRequestSeriesDialog(context);
                },
              ),
              SizedBox(height: 10),
              CustomElevatedButton(
                level: "Submit any Report",
                onTap: () {
                  Get.back();
                  showRequestReportDialog(context);
                },
                isBackgroundWhite: true,
                isBorderRed: true,
              ),
              SizedBox(height: 10),
              CustomElevatedButton(
                level: "Cancel Subscription",
                onTap: () {
                  Get.back();
                },
                isBackgroundWhite: true,
                isBorderRed: true,
              ),
              SizedBox(height: 10),
              CustomElevatedButton(
                level: isTermsAccepted!
                    ? "Disable Notifications"
                    : "Tern on Notifications",
                onTap: () {
                  Get.back();
                  if (isTermsAccepted) {
                    disableNotifications();
                  } else {
                    getAndSendFCMToken();
                  }
                },
                isBackgroundWhite: true,
                isBorderRed: true,
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      );
    }
  }

  Future<void> showRequestSeriesDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Request a racing series',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: SizedBox(
            height: 100,
            width: 300,
            child: TextFormField(
              controller: requestRaceNameController,
              decoration: InputDecoration(
                hintText: "Write your request...",
                hintStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.40),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Color(0xFFF3F4F6),
              ),
              maxLines: 5,
            ),
          ),
          actions: <Widget>[
            CustomElevatedButton(
              level: "Send a Request",
              onTap: () {
                submitRaceRequest(requestRaceNameController.text);
                requestRaceNameController.clear();
                Get.back();
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      },
    );
  }

  Future<void> showRequestReportDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Report',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: SizedBox(
            height: 100,
            width: 300,
            child: TextFormField(
              controller: reportMessageController,
              decoration: InputDecoration(
                hintText: "Write your report hare...",
                hintStyle: TextStyle(
                  color: Colors.black.withValues(alpha: 0.40),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Color(0xFFF3F4F6),
              ),
              maxLines: 5,
            ),
          ),
          actions: <Widget>[
            CustomElevatedButton(
              level: "Send a Request",
              onTap: () {
                submitReport(reportMessageController.text);
                reportMessageController.clear();
                Get.back();
              },
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      },
    );
  }

  var allRacesList = <RaceAPIModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedSponsorLogo = ''.obs;

  @override
  void onInit() {
    fetchAllRaces();
    super.onInit();
  }

  void setSponsorLogo(String logo) {
    selectedSponsorLogo.value = logo;
  }

  Future<void> fetchAllRaces() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final racesList = await RaceApiService.getAllRaces();
      allRacesList.value = racesList;
    } catch (e) {
      errorMessage.value = 'Failed to load races: $e';
      CustomSnackbar.show('Error', 'Failed to load races');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRaceRequest(String raceName) async {
    try {
      String? email = await SharedPrefHelper.getEmail();
      if (email != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/request/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_email": email.trim(),
            "request_details": raceName,
          }),
        );

        if (response.statusCode == 201) {
          CustomSnackbar.show(
            'Success',
            'Race request submitted successfully!',
          );
          await fetchAllRaces();
        } else {
          CustomSnackbar.show(
            'Error',
            'Failed to submit request: ${response.body}',
          );
          await fetchAllRaces();
        }
      }
    } catch (e) {
      CustomSnackbar.show('Error', 'Failed to submit request: ${e.toString()}');
    }
  }

  Future<void> submitReport(String reportName) async {
    try {
      String? email = await SharedPrefHelper.getEmail();
      if (email != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/report/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_email": email.trim(),
            "report_details": reportName,
          }),
        );

        if (response.statusCode == 201) {
          CustomSnackbar.show('Success', 'Your report submitted successfully!');
          await fetchAllRaces();
        } else {
          CustomSnackbar.show(
            'Error',
            'Failed to submit report: ${response.body}',
          );
          await fetchAllRaces();
        }
      }
    } catch (e) {
      CustomSnackbar.show('Error', 'Failed to submit report: ${e.toString()}');
    }
  }

  void signOut() {
    SharedPrefHelper.clearToken();
    SharedPrefHelper.clearEmail();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    allRacesList.clear();
    super.onClose();
  }

  Future<void> logoutOrDeleteAccountDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'What you want to do?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: SizedBox(height: 10, width: 300),
          actions: <Widget>[
            CustomElevatedButton(
              level: "Delete My Account",
              onTap: () {
                Get.back();
                deleteAccount();
              },
            ),
            SizedBox(height: 10),
            CustomElevatedButton(
              level: "Logout",
              onTap: () {
                Get.back();
                signOut();
              },
              isBackgroundWhite: true,
              isBorderRed: true,
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    try {
      final email = SharedPrefHelper.getEmail();
      final response = await http
          .delete(
            Uri.parse("$baseUrl/auth/user/$email"),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("Connection timed out. Please try again.");
            },
          );

      if (response.statusCode == 200) {
        CustomSnackbar.show("Success", "Your account has been deleted");
        SharedPrefHelper.clearToken();
        SharedPrefHelper.clearEmail();
        Get.offAllNamed(Routes.LOGIN);
      } else if (response.statusCode == 404) {
        CustomSnackbar.show("Error", "Your Email is not registered");
      } else {
        CustomSnackbar.show("Error", "Something went wrong, Please try again");
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

  Future<void> disableNotifications() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: false,
            badge: false,
            sound: false,
          );

      CustomSnackbar.show(
        "Notifications Disabled",
        "You will no longer receive push notifications.",
      );

      postCredential(fcmToken: "null");
      await SharedPrefHelper.saveIsTermsAccepted(false);
    } catch (e) {
      CustomSnackbar.show("Error", "Could not disable notifications: $e");
    }
  }

  Future<void> getAndSendFCMToken() async {
    try {
      isLoading.value = true;
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
      } else {
        postCredential(fcmToken: token);
        await SharedPrefHelper.saveIsTermsAccepted(true);
      }
    } catch (e) {
      CustomSnackbar.show("Error", "Error getting FCM token: $e");
      throw Exception("Error getting FCM token: $e");
    }
  }

  Future<void> postCredential({required String fcmToken}) async {
    try {
      final email = await SharedPrefHelper.getEmail();
      if (email == null) {
        return;
      }

      final response = await http
          .post(
            Uri.parse("$baseUrl/user/registration"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"uid": email.trim(), "fcmToken": fcmToken}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException("Connection timed out. Please try again.");
            },
          );
      isLoading.value = false;
      if (response.statusCode == 201) {
        final decodedResponse = jsonDecode(response.body);
        await SharedPrefHelper.saveToken(decodedResponse["access_token"]);
        await fetchAllRaces();
      } else if (response.statusCode == 404) {
        CustomSnackbar.show("Email Error", "Your Email is Wrong");
      } else if (response.statusCode == 400) {
        CustomSnackbar.show("Password Error", "Your Password is Wrong");
      } else if (response.statusCode == 401) {
        CustomSnackbar.show(
          "Authorization Error",
          "Your otp code is not varified",
        );
      } else {
        CustomSnackbar.show("Error", "Something went wrong");
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
