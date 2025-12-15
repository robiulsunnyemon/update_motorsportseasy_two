import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:motor_sport_easy/app/data/constants/app_color.dart';
import 'app/routes/app_pages.dart';
class MotorSportEasyApp extends StatelessWidget {
  final String initialRoute;
  const MotorSportEasyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "MotorSportEasy",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.primaryColor,
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.white),
          thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Color(0xFF484848),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          labelStyle: TextStyle(fontFamily: 'Inter'),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 18, // Use fixed size or calculate in responsive way
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 30),
    );
  }
}