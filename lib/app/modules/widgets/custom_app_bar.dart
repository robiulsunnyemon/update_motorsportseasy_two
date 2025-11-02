
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(color: const Color(0xFFDC2626)),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   spacing: 8,
      //   children: [
      //     Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       spacing: 1,
      //       children: [
      //         SizedBox(
      //           width: 361,
      //           child: Text(
      //             'Motorsport Easy',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 24,
      //               fontFamily: 'Inter',
      //               fontWeight: FontWeight.w700,
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           width: 361,
      //           child: Text(
      //             'Never miss a race again',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 12,
      //               fontFamily: 'Inter',
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      child: Image.asset("assets/images/img.png"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
