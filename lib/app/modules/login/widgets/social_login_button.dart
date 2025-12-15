

import 'package:flutter/material.dart';

import '../../../data/constants/app_color.dart';
class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const SocialLoginButton({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Inter',
                  fontSize: 16, fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ),
    );
  }
}
