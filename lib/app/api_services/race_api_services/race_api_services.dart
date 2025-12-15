
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/model/race_api_model.dart';
import '../base_url.dart';



class RaceApiService {



  static Future<List<RaceAPIModel>> getAllRaces() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/race/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );



      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((raceJson) => RaceAPIModel.fromJson(raceJson)).toList();
      } else {
        throw Exception('Failed to load races: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching races: $e');
    }
  }

  static Future<RaceAPIModel> getRaceById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/race/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return RaceAPIModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load race: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching race: $e');
    }
  }


}