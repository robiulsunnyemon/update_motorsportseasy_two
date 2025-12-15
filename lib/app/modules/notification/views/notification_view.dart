import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/constants/app_color.dart';
import '../../widgets/custom_appbar_title.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 120, title: const CustomAppbarTitle()),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColor.primaryColor,));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }

        final response = controller.notifications;
        if (response.isEmpty) {
          return const Center(child: Text('You have no notifications'));
        }

        return RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: () async {
            await controller.fetchNotifications();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:  EdgeInsets.all(8.0),
            itemCount: response.length,
            itemBuilder: (context, index) {
              int i = response.length - index - 1;
              final notification = response[i];
              String formatted = DateFormat('dd/MM/yyyy hh:mm a')
                  .format(notification.createdAt.toLocal());
              return Card(
                color: AppColor.white,
                child: ListTile(
                  title: Text(notification.notificationTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.notificationBody),
                      Text(formatted),
                    ],
                  ),

                ),
              );

            },
          ),
        );
      }),
    );
  }
}
