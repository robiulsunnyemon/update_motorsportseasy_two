import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/model/event_api_model.dart';
import '../base_url.dart';


class EventApiService {


 static Future<List<EventAPIModel>> fetchEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));


    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => EventAPIModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
