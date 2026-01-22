import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomEventCard extends StatelessWidget {
  final String eventLocation;
  final DateTime eventDate;
  final String tvName;
  final String radioName;
  final String sponsorLogo;

  // final String sponsorLogo;
  const CustomEventCard({
    super.key,
    required this.eventLocation,
    required this.eventDate,
    required this.tvName,
    required this.radioName,
    required this.sponsorLogo,
    // required this.sponsorLogo,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime internationalTime = eventDate;
    DateTime datetime = internationalTime.toLocal();
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final double logoSize = screenHeight * 0.09; // 5% of screen height

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFA19797)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      eventLocation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 16 / 360,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.alarm, size: screenWidth * 15 / 360),
                        SizedBox(width: 5),
                        Text(
                          'Start Time: ${DateFormat.jm().format(datetime)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 11 / 360,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.tv_rounded, size: screenWidth * 15 / 360),
                        SizedBox(width: 5),
                        Text(
                          'TV: $tvName',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 10 / 360,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.radio, size: screenWidth * 15 / 360),
                        SizedBox(width: 5),
                        Text(
                          'Radio: $radioName',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 10 / 360,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // DateFormat.yMd().format(eventDate),
                  DateFormat('dd/MM/yyyy').format(eventDate),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 16 / 360,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: logoSize,
                  height: logoSize,
                  child: Image.network(
                    sponsorLogo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}
