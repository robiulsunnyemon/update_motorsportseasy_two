import 'package:get/get.dart';

import '../controllers/racing_details_controller.dart';

class RacingDetailsBinding extends Bindings {
  @override
  void dependencies() {

    final raceId = Get.parameters['raceId'] ??
        Get.arguments?['raceId']?.toString();

    if (raceId == null || raceId.isEmpty) {
      throw "Race ID is required for SingleRaceEventDashboardController";
    }
    final raceName = Get.parameters['raceName'] ??
        Get.arguments?['raceName']?.toString();

    if (raceName == null || raceName.isEmpty) {
      throw "Race raceName is required for SingleRaceEventDashboardController";
    }
    Get.lazyPut<RacingDetailsController>(
      () => RacingDetailsController(
        raceId: int.parse(raceId),
        raceName: raceName,
      ),
    );
  }
}
