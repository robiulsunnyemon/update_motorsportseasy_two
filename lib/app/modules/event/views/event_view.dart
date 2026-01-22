import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motor_sport_easy/app/data/constants/app_color.dart';
import 'package:motor_sport_easy/app/modules/racing_details/controllers/racing_details_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../widgets/custom_appbar_title.dart';
import '../../widgets/custom_event_card.dart';
import '../controllers/event_controller.dart';

class EventView extends GetView<EventController> {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 120 / 652,
        title: CustomAppbarTitle(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 8.0 / 360,
                vertical: screenWidth * 15 / 360,
              ),
              child: Text(
                'All Events',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: screenWidth * 24 / 360,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                ),
              );
            } else if (controller.allEvents.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Event is not available")),
                ),
              );
            } else {
              return SliverList.builder(
                itemCount: controller.allEvents.length,
                itemBuilder: (context, index) {
                  final eventData = controller.allEvents[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: CustomEventCard(
                        eventDate: eventData.startedAt,
                        eventLocation: eventData.location,
                        tvName: eventData.tvBroadcastChanel,
                        radioName: eventData.radioBroadcastChanel,
                        sponsorLogo: controller.getSponsorLogoForEvent(eventData), // এখানে logo পাঠান
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ],
      ),
    );
  }
}
