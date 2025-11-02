import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/model/notification_api_model.dart';
import '../../shared_pref_helper/shared_pref_helper.dart';
import '../contants.dart';


class NotificationApiService {
  static Future<List<NotificationApiModel>> fetchNotifications() async {
    String? fastAPIToken =await SharedPrefHelper.getToken();

    final response = await http.get(
        Uri.parse('$baseUrl/notification_box/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $fastAPIToken',
        },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => NotificationApiModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
