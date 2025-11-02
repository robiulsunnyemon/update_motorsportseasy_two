
import 'package:get/get.dart';
import '../../../api_services/event_api_services/event_api_services.dart';
import '../../../data/model/event_api_model.dart';

class EventController extends GetxController {

  var allEvents = <EventAPIModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    try {
      isLoading.value = true;
      final fetchedEvents = await EventApiService.fetchEvents();
      allEvents.assignAll(fetchedEvents);
      isLoading.value=false;
    } catch (e) {
      isLoading.value=false;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

}