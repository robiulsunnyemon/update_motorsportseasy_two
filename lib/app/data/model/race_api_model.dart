// models/race_model.dart
class RaceAPIModel {
  final int id;
  final String name;
  final String imageLogo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RaceEventAPIModel> events;

  RaceAPIModel({
    required this.id,
    required this.name,
    required this.imageLogo,
    required this.createdAt,
    required this.updatedAt,
    required this.events,
  });

  factory RaceAPIModel.fromJson(Map<String, dynamic> json) {
    return RaceAPIModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageLogo: json['image_logo'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      events: (json['events'] as List<dynamic>?)
          ?.map((eventJson) => RaceEventAPIModel.fromJson(eventJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_logo': imageLogo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'events': events.map((event) => event.toJson()).toList(),
    };
  }
}

class RaceEventAPIModel {
  final int id;
  final int raceId;
  final String tvBroadcastChanel;
  final String radioBroadcastChanel;
  final String location;
  final DateTime startedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  RaceEventAPIModel({
    required this.id,
    required this.raceId,
    required this.tvBroadcastChanel,
    required this.radioBroadcastChanel,
    required this.location,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RaceEventAPIModel.fromJson(Map<String, dynamic> json) {
    return RaceEventAPIModel(
      id: json['id'] ?? 0,
      raceId: json['race_id'] ?? 0,
      tvBroadcastChanel: json['tv_broadcast_chanel'] ?? '',
      radioBroadcastChanel: json['radio_broadcast_chanel'] ?? '',
      location: json['location'] ?? '',
      startedAt: DateTime.parse(json['started_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'race_id': raceId,
      'tv_broadcast_chanel': tvBroadcastChanel,
      'radio_broadcast_chanel': radioBroadcastChanel,
      'location': location,
      'started_at': startedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}