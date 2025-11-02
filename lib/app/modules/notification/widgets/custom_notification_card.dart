import 'package:flutter/material.dart';

class CustomNotificationCard extends StatelessWidget {
  final String notificationTitle;
  final String notificationBody;
   final DateTime? notificationDateTime;
  const CustomNotificationCard({super.key, required this.notificationTitle, this.notificationDateTime, required this.notificationBody});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          SizedBox(
            width: 329,
            child: Text(
              notificationTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 329,
            child: Text(
              notificationBody,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
