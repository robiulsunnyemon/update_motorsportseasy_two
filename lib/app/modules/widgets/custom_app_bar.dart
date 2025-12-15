
import 'package:flutter/material.dart';

import '../../data/constants/app_color.dart';

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
      decoration: BoxDecoration(color: AppColor.primaryColor),
      child: Image.asset("assets/images/img.png"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
