import 'package:get/get.dart';

import '../controllers/request_form_controller.dart';

class RequestFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestFormController>(
      () => RequestFormController(),
    );
  }
}
