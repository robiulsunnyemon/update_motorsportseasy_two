import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../api_services/base_url.dart';
import '../../../routes/app_pages.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../../utils/custom_snackbar.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isActiveNotification = true.obs;
  var userEmail = "".obs;

  void signOut() {
    SharedPrefHelper.clearToken();
    SharedPrefHelper.clearEmail();
    Get.offAllNamed(Routes.LOGIN);
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
      checkNotificationState();
    } catch (e) {
      CustomSnackbar.show("Error", "Could not disable notifications: $e");
    }
  }

  Future<void> notificationActive() async {
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
        checkNotificationState();
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

  Future<void> checkNotificationState() async {
    final isTermsAccepted = await SharedPrefHelper.getIsTermsAccepted();
    if (isTermsAccepted == true) {
      isActiveNotification.value = true;
    } else {
      isActiveNotification.value = false;
    }
  }

  var profileImagePath = Rxn<String>();

  Future<void> pickAndSaveProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        await SharedPrefHelper.saveProfileImagePath(pickedFile.path);

        profileImagePath.value = pickedFile.path;

        CustomSnackbar.show("Success", "Profile image updated successfully!");
      } else {
        CustomSnackbar.show("Canceled", "No image selected.");
      }
    } catch (e) {
      CustomSnackbar.show("Error", "Failed to pick image: $e");
    }
  }

  Future<void> loadProfileImage() async {
    final path = await SharedPrefHelper.getProfileImagePath();
    profileImagePath.value = path;
  }

  @override
  void onInit() {
    checkNotificationState();
    getUserEmail();
    loadProfileImage();
    super.onInit();
  }

  Future<void> getUserEmail() async {
    final email = await SharedPrefHelper.getEmail();
    userEmail.value = email ?? '';
  }

  Future<void> deleteAccount() async {
    try {
      final email = await SharedPrefHelper.getEmail();
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
}
