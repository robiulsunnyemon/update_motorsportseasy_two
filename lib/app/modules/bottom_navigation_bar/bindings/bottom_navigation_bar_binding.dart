import 'package:get/get.dart';
import 'package:motor_sport_easy/app/modules/home/controllers/home_controller.dart';
import 'package:motor_sport_easy/app/modules/notification/controllers/notification_controller.dart';

import '../../event/controllers/event_controller.dart';
import '../controllers/bottom_navigation_bar_controller.dart';

class BottomNavigationBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavigationBarController>(
      () => BottomNavigationBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<EventController>(
      () => EventController(),
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }
}
