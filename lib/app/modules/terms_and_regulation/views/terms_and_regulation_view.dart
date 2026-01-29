import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/data/constants/app_color.dart';
import '../controllers/terms_and_regulation_controller.dart';

class TermsAndRegulationView extends GetView<TermsAndRegulationController> {
  const TermsAndRegulationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Regulations',
          style: TextStyle(color: AppColor.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''
Welcome to Motor Sport Easy App.

Please read our Terms & Regulations carefully:

We may send you push notifications about race updates, offers, and alerts.  
Notifications will only be sent if you grant permission.  
You can disable notifications anytime from your device settings.  
By clicking "Agree", you accept our terms and allow notifications.  
You can also choose "Skip" to continue without enabling notifications.
                  ''',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: "PlayfairDisplay",
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: controller.agreeAndEnableNotifications,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColor.primaryColor,
              ),
              child:Text(
                "Agree & Enable Notifications",
                style: TextStyle(fontSize: 16, color: AppColor.white),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: controller.skipNotifications,
              child: Text(
                "Skip / Disagree",
                style: TextStyle(color: AppColor.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
