import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:motor_sport_easy/app/modules/home/views/home_view.dart';
import '../../event/views/event_view.dart';
import '../../notification/views/notification_view.dart';

class BottomNavigationBarController extends GetxController {

  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  final List<Widget> pages = [
    HomeView(),
    EventView(),
    NotificationView(),
  ];
}
