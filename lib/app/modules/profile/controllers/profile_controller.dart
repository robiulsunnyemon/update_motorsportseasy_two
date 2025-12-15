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




class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isActiveNotification=true.obs;
  var userEmail="".obs;

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

      Get.snackbar(
        "Notifications Disabled",
        "You will no longer receive push notifications.",
        snackPosition: SnackPosition.BOTTOM,
      );

      postCredential(fcmToken: "null");
      await SharedPrefHelper.saveIsTermsAccepted(false);
      checkNotificationState();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not disable notifications: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
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
      Get.snackbar("Error", "Error getting FCM token: $e");
      throw Exception("Error getting FCM token: $e");
    }
  }

  Future<void> postCredential({required String fcmToken}) async {
    try {
      final email =await SharedPrefHelper.getEmail();
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
        Get.snackbar("Email Error", "Your Email is Wrong");
      } else if (response.statusCode == 400) {
        Get.snackbar("Password Error", "Your Password is Wrong");
      } else if (response.statusCode == 401) {
        Get.snackbar("Authorization Error", "Your otp code is not varified");
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } on SocketException {
      Get.snackbar(
        "Network Error",
        "No internet connection. Please check your network.",
      );
    } on TimeoutException catch (e) {
      Get.snackbar(
        "Timeout",
        e.message ?? "The request took too long to complete.",
      );
    } on FormatException {
      Get.snackbar(
        "Response Error",
        "Invalid response format from the server.",
      );
    } catch (e) {

      Get.snackbar(
        "Unexpected Error",
        "Something went wrong. Please try again.",
      );
    }
  }

  Future<void> checkNotificationState() async {
    final isTermsAccepted =await SharedPrefHelper.getIsTermsAccepted();
    if(isTermsAccepted==true){
      isActiveNotification.value=true;
    }else{
      isActiveNotification.value=false;
    }
  }


  var profileImagePath = Rxn<String>();



  Future<void> pickAndSaveProfileImage() async {
    final ImagePicker picker = ImagePicker();
    try {

      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {

        await SharedPrefHelper.saveProfileImagePath(pickedFile.path);

        profileImagePath.value = pickedFile.path;

        Get.snackbar("Success", "Profile image updated successfully!", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Canceled", "No image selected.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e", snackPosition: SnackPosition.BOTTOM);
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
    final email =await  SharedPrefHelper.getEmail();
    userEmail.value=email??'';
  }

  Future<void> deleteAccount() async {
    try {
      final email =await SharedPrefHelper.getEmail();
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
        Get.snackbar("Success", "Your account has been deleted");
        SharedPrefHelper.clearToken();
        SharedPrefHelper.clearEmail();
        Get.offAllNamed(Routes.LOGIN);
      } else if (response.statusCode == 404) {
        Get.snackbar("Error", "Your Email is not registered");
      } else {
        Get.snackbar("Error", "Something went wrong, Please try again");
      }
    } on SocketException {
      Get.snackbar(
        "Network Error",
        "No internet connection. Please check your network.",
      );
    } on TimeoutException catch (e) {
      Get.snackbar(
        "Timeout",
        e.message ?? "The request took too long to complete.",
      );
    } on FormatException {
      Get.snackbar(
        "Response Error",
        "Invalid response format from the server.",
      );
    } catch (e) {
      Get.snackbar(
        "Unexpected Error",
        "Something went wrong. Please try again.",
      );
    }
  }
}

