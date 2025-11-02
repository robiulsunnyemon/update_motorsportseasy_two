
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String level;
  final bool isBackgroundWhite;
  final bool isBorderRed;
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.level,
    this.isBackgroundWhite=false,
    this.isBorderRed=false,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(
            isBackgroundWhite?Colors.white:const Color(0xFFDC2626),
          ),
          elevation: WidgetStatePropertyAll<double>(0.2),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: isBorderRed?const BorderSide(color: Color(0xFFDC2626)):BorderSide.none
            ),
          ),
        ),
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              level,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isBackgroundWhite?const Color(0xFFDC2626): Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
