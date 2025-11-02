import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await agreeAndEnableNotifications();
  final String? token = await SharedPrefHelper.getToken();
  runApp(
    MotorSportEasyApp(
      initialRoute: (token==null?Routes.TERMS_AND_REGULATION:Routes.SUBSCRIPTION)
    ),
  );
}



Future<void> agreeAndEnableNotifications() async {


  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true,);

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    await SharedPrefHelper.saveIsAcceptedNotification(true);
  } else {
    await SharedPrefHelper.saveIsAcceptedNotification(false);
  }
}


