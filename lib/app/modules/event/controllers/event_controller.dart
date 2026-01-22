import 'package:get/get.dart';
import '../../../api_services/event_api_services/event_api_services.dart';
import '../../../api_services/race_api_services/race_api_services.dart';
import '../../../data/model/event_api_model.dart';
import '../../../data/model/race_api_model.dart';

class EventController extends GetxController {

  var allEvents = <EventAPIModel>[].obs;
  var allRaces = <RaceAPIModel>[].obs; // রেস লিস্ট রাখার জন্য
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchEventsAndRaces();
    super.onInit();
  }

  Future<void> fetchEventsAndRaces() async {
    try {
      isLoading.value = true;

      // একসাথে events এবং races fetch করুন
      final fetchedEvents = await EventApiService.fetchEvents();
      final fetchedRaces = await RaceApiService.getAllRaces();

      allRaces.assignAll(fetchedRaces);

      final now = DateTime.now();
      final filteredEvents = fetchedEvents.where((event) {
        return event.startedAt.isAfter(now.subtract(Duration(hours: 1)));
      }).toList();
      filteredEvents.sort((a, b) => a.startedAt.compareTo(b.startedAt));
      allEvents.assignAll(filteredEvents);

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // একটি event এর জন্য sponsor logo খুঁজে বের করার method
  String getSponsorLogoForEvent(EventAPIModel event) {
    try {
      // EventAPIModel এ যদি raceId থাকে
      final race = allRaces.firstWhere(
            (race) => race.id == event.raceId, // অথবা event.race?.id
        orElse: () => allRaces.first,
      );
      return race.imageLogo;
    } catch (e) {
      return "";
    }
  }
}