import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:motor_sport_easy/motor_sport_easy_app.dart';
import 'app/routes/app_pages.dart';
import 'app/shared_pref_helper/shared_pref_helper.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('userBox');
  await Hive.openBox('settingsBox');
  await Hive.openBox('notificationBox');


  await Hive.openBox<String>('profileImageBox');


  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  final String? token = await SharedPrefHelper.getToken();
  final bool? termsAndRegulationStatus = await SharedPrefHelper.getIsTermsAccepted();
  final subscriptionState = await SharedPrefHelper.getSubscriptionState();

  print('Token: $token, Terms Accepted: $termsAndRegulationStatus');

  // Improved initial route logic
  String initialRoute;

  if (termsAndRegulationStatus == null || termsAndRegulationStatus == false) {
    // First time user or haven't accepted terms
    initialRoute = Routes.TERMS_AND_REGULATION;
  } else if (token == null) {
    // Terms accepted but not logged in
    initialRoute = Routes.LOGIN;
  } else {
    // Terms accepted and logged in
    if(subscriptionState==true) {
      initialRoute = Routes.BOTTOM_NAVIGATION_BAR;
    }
    else{
      initialRoute = Routes.SUBSCRIPTION;
    }
  }



  runApp(
    MotorSportEasyApp(initialRoute: initialRoute),
  );

}