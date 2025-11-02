import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/api_services/contants.dart';
import '../../../api_services/race_api_services/race_api_services.dart';
import '../../../data/model/race_api_model.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';


class RacingDetailsController extends GetxController {
  final int raceId;
  final String raceName;

  RacingDetailsController({required this.raceId, required this.raceName});



  RxBool is12Hour = false.obs;
  RxBool is3Hour = false.obs;
  RxBool is1Hour = false.obs;


  final isLoading = false.obs;

  Future<void> _loadNotificationState() async {
    is3Hour.value= await SharedPrefHelper.getNotification(raceId: raceId, hour: 3);
    is1Hour.value= await SharedPrefHelper.getNotification(raceId: raceId, hour: 1);
    is12Hour.value= await SharedPrefHelper.getNotification(raceId: raceId, hour: 12);
    update();

  }


  Future<void> set12Hour() async {
    is12Hour.value = !is12Hour.value;


    if (is12Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId,hour:12 );
      sendNotificationFastAPI(
        hour: 12,
      );
    }else{
      await SharedPrefHelper.clearNotification(raceId: raceId, hour: 12);
      await deletedNotification(hour: 12);
    }
  }

  Future<void> set3Hour() async {
    is3Hour.value = !is3Hour.value;

    if (is3Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId,hour:3 );
      await sendNotificationFastAPI(
        hour: 3,
      );
    }else{
      await SharedPrefHelper.clearNotification(raceId: raceId, hour: 3);
      deletedNotification(hour: 3);
    }
  }

  Future<void> set1Hour() async {
    is1Hour.value = !is1Hour.value;

    if (is1Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId,hour:1 );
      sendNotificationFastAPI(
        hour: 1,
      );
    }else{
      await SharedPrefHelper.clearNotification(raceId: raceId, hour: 1);
      await deletedNotification(hour: 1);
    }
  }


  var selectedRace = Rx<RaceAPIModel?>(null);
  Future<void> fetchRaceById(int id) async {
    try {
      isLoading.value = true;
      await _loadNotificationState();
      final race = await RaceApiService.getRaceById(id);
      selectedRace.value = race;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load race details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchRaceById(raceId);
    super.onInit();
  }

  Future<void> sendNotificationFastAPI({required int hour,}) async {
    final String apiUrl =
        "$baseUrl/notifications/";
    String? fastAPIToken = await SharedPrefHelper.getToken();
    if (fastAPIToken != null) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $fastAPIToken',
          },
          body: jsonEncode({
            "race_id": raceId,
            "notification_hour": hour
          }),
        );

        if (response.statusCode == 201) {
          Get.snackbar("Notification Set", "Notification set successfully for $hour hour");
        } else {
          Get.snackbar("Notification Failed",
              "Failed to set notification. Status: ${response.statusCode}");
        }
      } catch (e) {
        Get.snackbar("Notification Failed", "Error sending notification: $e");
        throw Exception('Failed to send notification $e');
      }
    }
  }



  Future<void> deletedNotification({required int hour}) async {
    String? fastAPIToken = await SharedPrefHelper.getToken();
    final response = await http.delete(
        Uri.parse('$baseUrl/notifications/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $fastAPIToken',
        },
        body: jsonEncode({
          "race_id": raceId,
          "notification_hour": hour
        }),
    );
    if (response.statusCode == 204) {
      Get.snackbar("Alart", "Notification Stop successfully");
    } else {
      throw Exception('Failed to load notifications');
    }
  }

}


