
import 'package:get/get.dart';
import '../../../api_services/notification_api_service/notification_api_services.dart';
import '../../../data/model/notification_api_model.dart';


class NotificationController extends GetxController {


  RxList<NotificationApiModel> notifications = <NotificationApiModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final fetchedNotifications = await NotificationApiService.fetchNotifications();
      notifications.assignAll(fetchedNotifications);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


}
