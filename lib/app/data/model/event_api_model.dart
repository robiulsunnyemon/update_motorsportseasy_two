class EventAPIModel {
  final int id;
  final int raceId;
  final String tvBroadcastChanel;
  final String radioBroadcastChanel;
  final String location;
  final DateTime startedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventAPIModel({
    required this.id,
    required this.raceId,
    required this.tvBroadcastChanel,
    required this.radioBroadcastChanel,
    required this.location,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventAPIModel.fromJson(Map<String, dynamic> json) {
    return EventAPIModel(
      id: json['id'],
      raceId: json['race_id'],
      tvBroadcastChanel: json['tv_broadcast_chanel'] ?? '',
      radioBroadcastChanel: json['radio_broadcast_chanel'] ?? '',
      location: json['location'] ?? '',
      startedAt: DateTime.parse(json['started_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
