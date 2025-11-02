class NotificationApiModel {
  final int userId;
  final String notificationTitle;
  final String notificationBody;
  final DateTime createdAt;

  NotificationApiModel({
    required this.userId,
    required this.notificationTitle,
    required this.notificationBody,
    required this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    return NotificationApiModel(
      userId: json['user_id'],
      notificationTitle: json['notification_title'] ?? '',
      notificationBody: json['notification_body'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
