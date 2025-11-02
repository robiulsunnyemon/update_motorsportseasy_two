
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/constants/app_color.dart';
import '../../widgets/custom_appbar_title.dart';
import '../../widgets/custom_event_card.dart';
import '../controllers/racing_details_controller.dart';

class RacingDetailsView extends GetView<RacingDetailsController> {
  const RacingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight*120/752,
        title: CustomAppbarTitle(),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: screenWidth * 300 / 360,
                    child: Text(
                      controller.raceName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              )

            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Obx(
                          () => Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '12 Hour before race',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: controller.is12Hour.value,
                                  activeTrackColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    controller.set12Hour();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '3 Hour before race',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: controller.is3Hour.value,
                                  activeTrackColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    controller.set3Hour();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF3F4F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '1 Hour before race',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Switch(
                                  value: controller.is1Hour.value,
                                  activeTrackColor: AppColor.primaryColor,
                                  onChanged: (value) {
                                    controller.set1Hour();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              );
            } else if (controller.selectedRace.value == null || controller.selectedRace.value!.events.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Text("No events available"),
                )),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final event = controller.selectedRace.value!.events[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomEventCard(
                      eventDate: event.startedAt,
                      eventLocation: event.location,
                      tvName: event.tvBroadcastChanel,
                      radioName: event.radioBroadcastChanel,
                    ),
                  );
                }, childCount: controller.selectedRace.value?.events.length),
              );
            }
          }),
        ],
      ),
    );
  }
}

