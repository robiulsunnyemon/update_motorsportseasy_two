import 'package:get/get.dart';
import 'package:motor_sport_easy/app/shared_pref_helper/shared_pref_helper.dart';
import '../../../routes/app_pages.dart';


class TermsAndRegulationController extends GetxController {


  Future<void> agreeAndEnableNotifications() async {
    await SharedPrefHelper.saveIsTermsAccepted(true);
    Get.offAllNamed(Routes.LOGIN);
  }


  Future<void> skipNotifications() async {
    await SharedPrefHelper.saveIsTermsAccepted(false);
    Get.offAllNamed(Routes.LOGIN);
  }


}
