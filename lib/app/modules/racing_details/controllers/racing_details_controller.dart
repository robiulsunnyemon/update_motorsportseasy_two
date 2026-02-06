import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motor_sport_easy/app/api_services/base_url.dart';
import '../../../api_services/race_api_services/race_api_services.dart';
import '../../../data/model/race_api_model.dart';
import '../../../shared_pref_helper/shared_pref_helper.dart';
import '../../../utils/custom_snackbar.dart';

class RacingDetailsController extends GetxController {
  final int raceId;
  final String raceName;
  late final String sponsorLogo;

  RacingDetailsController({required this.raceId, required this.raceName});

  RxBool is12Hour = false.obs;
  RxBool is3Hour = false.obs;
  RxBool is1Hour = false.obs;

  final isLoading = false.obs;

  Future<void> _loadNotificationState() async {
    is3Hour.value = await SharedPrefHelper.getNotification(
      raceId: raceId,
      hour: 3,
    );
    is1Hour.value = await SharedPrefHelper.getNotification(
      raceId: raceId,
      hour: 1,
    );
    is12Hour.value = await SharedPrefHelper.getNotification(
      raceId: raceId,
      hour: 12,
    );
    update();
  }

  Future<void> set12Hour() async {
    is12Hour.value = !is12Hour.value;

    if (is12Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId, hour: 12);
      sendNotificationFastAPI(hour: 12);
    } else {
      await SharedPrefHelper.clearNotification(raceId: raceId, hour: 12);
      await deletedNotification(hour: 12);
    }
  }

  Future<void> set3Hour() async {
    is3Hour.value = !is3Hour.value;

    if (is3Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId, hour: 3);
      await sendNotificationFastAPI(hour: 3);
    } else {
      await SharedPrefHelper.clearNotification(raceId: raceId, hour: 3);
      deletedNotification(hour: 3);
    }
  }

  Future<void> set1Hour() async {
    is1Hour.value = !is1Hour.value;

    if (is1Hour.value) {
      await SharedPrefHelper.saveNotification(raceId: raceId, hour: 1);
      sendNotificationFastAPI(hour: 1);
    } else {
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
      final now = DateTime.now();

      // শুধু এখনও চলমান বা ভবিষ্যতের ইভেন্ট রাখুন
      final filteredEvents = race.events.where((event) {
        return event.startedAt.isAfter(now.subtract(Duration(hours: 1)));
      }).toList();

      // সময় অনুযায়ী সাজানো
      filteredEvents.sort((a, b) => a.startedAt.compareTo(b.startedAt));

      // নতুন race copy তৈরি করে filtered events assign করা
      selectedRace.value = race.copyWith(events: filteredEvents);
    } catch (e) {
      CustomSnackbar.show('Error', 'Failed to load race details');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    final args = Get.arguments as Map<String, dynamic>;
    sponsorLogo = args['sponsorLogo'];
    fetchRaceById(raceId);
    super.onInit();
  }

  Future<void> sendNotificationFastAPI({required int hour}) async {
    final String apiUrl = "$baseUrl/notifications/";
    String? fastAPIToken = await SharedPrefHelper.getToken();
    if (fastAPIToken != null) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $fastAPIToken',
          },
          body: jsonEncode({"race_id": raceId, "notification_hour": hour}),
        );

        if (response.statusCode == 201) {
          CustomSnackbar.show(
            "Notification Set",
            "Notification set successfully for $hour hour",
          );
        } else {
          CustomSnackbar.show(
            "Notification Failed",
            "Failed to set notification. Status: ${response.statusCode}",
          );
        }
      } catch (e) {
        CustomSnackbar.show(
          "Notification Failed",
          "Error sending notification: $e",
        );
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
      body: jsonEncode({"race_id": raceId, "notification_hour": hour}),
    );
    if (response.statusCode == 204) {
      CustomSnackbar.show("Alert", "Notification Stop successfully");
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
