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

    double screenWidth=MediaQuery.of(context).size.width;

    return  GetMaterialApp(
      title: "MotorSportEasy",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          // bottomAppBarTheme: BottomAppBarThemeData(
          //     color: Colors.white,
          //     surfaceTintColor: Colors.white
          // ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.primaryColor,

          ),
          switchTheme: SwitchThemeData(
            trackOutlineColor: WidgetStatePropertyAll<Color>(Colors.white),
            thumbColor: WidgetStatePropertyAll<Color>(Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle:  TextStyle(
              color: const Color(0xFF484848),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelStyle: TextStyle(
              fontFamily: 'Inter'
          )
          ),
          textTheme: TextTheme(
            headlineMedium: TextStyle(
              color: Colors.black,
              fontSize: screenWidth*18/360,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),

          )
      ),
      defaultTransition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 30),
    );
  }
}
