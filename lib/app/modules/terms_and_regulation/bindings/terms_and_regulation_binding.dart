import 'package:get/get.dart';

import '../controllers/terms_and_regulation_controller.dart';

class TermsAndRegulationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndRegulationController>(
      () => TermsAndRegulationController(),
    );
  }
}
