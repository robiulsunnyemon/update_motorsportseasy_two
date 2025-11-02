import 'package:flutter/material.dart';

class CustomLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget text;
  final bool isBackgroundWhite;
  final bool isBorderRed;
  const CustomLoginButton({
    super.key,
    required this.onTap,
    required this.text,
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
            child: text,
          ),
        ),
      ),
    );
  }
}