// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPrefHelper {
//   static const String _uidKey = 'uid';
//
//   static Future<void> saveUid(String uid) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_uidKey, uid);
//   }
//
//   static Future<String?> getUid() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_uidKey);
//   }
//
//   static Future<void> clearUid() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_uidKey);
//     await clearToken();
//   }
//
//
//   static Future<void> saveEmail(String email) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('email', email);
//   }
//
//   static Future<String?> getEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('email');
//   }
//
//   static Future<void> clearEmail() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('email');
//   }
//
//
//
//   static Future<void> saveIsTermsAccepted(bool response) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isTermsAccepted', response);
//   }
//
//   static Future<bool?> getIsTermsAccepted() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('isTermsAccepted');
//   }
//
//   static Future<void> clearIsTermsAccepted() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('isTermsAccepted');
//
//   }
//
//
//   static Future<void> saveIsAcceptedNotification(bool response) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isAcceptedNotification', response);
//   }
//
//   static Future<bool?> getIsAcceptedNotification() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('isAcceptedNotification');
//   }
//
//   static Future<void> removeIsAcceptedNotification() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('isAcceptedNotification');
//
//   }
//
//
//
//
//   static Future<void> saveNotificationState(String raceId, Map<String, bool> state) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('notif_$raceId', json.encode(state));
//   }
//
//   static Future<Map<String, bool>> getNotificationState(String raceId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final stateString = prefs.getString('notif_$raceId');
//     if (stateString != null) {
//       final stateMap = json.decode(stateString) as Map<String, dynamic>;
//       return {
//         '8hour': stateMap['8hour'] ?? false,
//         '3hour': stateMap['3hour'] ?? false,
//         '6hour': stateMap['6hour'] ?? false,
//       };
//     }
//     return {'8hour': false, '3hour': false, '6hour': false};
//   }
//
//   static Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//   }
//
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }
//
//   static Future<void> clearToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//
//   }
//
//
//
//   static Future<void> saveNotification({required int raceId,required int hour})async{
//     final prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString('$raceId$hour', "active");
//   }
//
//   static Future<bool> getNotification({required int raceId,required int hour})async{
//     final prefs = await SharedPreferences.getInstance();
//     final notificationValue= prefs.getString('$raceId$hour');
//     if(notificationValue=="active"){
//       return true;
//     }else{
//       return false;
//     }
//   }
//
//   static Future<void> clearNotification({required int raceId,required int hour})async{
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('$raceId$hour');
//   }
//
//
// }



// import 'dart:convert';
// import 'package:get_storage/get_storage.dart';
//
// class SharedPrefHelper {
//   static final GetStorage _storage = GetStorage();
//
//   // Initialize GetStorage (একবারই call করতে হবে main.dart এ)
//   static Future<void> init() async {
//     await GetStorage.init();
//   }
//
//   static const String _uidKey = 'uid';
//
//   static Future<void> saveUid(String uid) async {
//     await _storage.write(_uidKey, uid);
//   }
//
//   static String? getUid() {
//     return _storage.read<String>(_uidKey);
//   }
//
//   static Future<void> clearUid() async {
//     await _storage.remove(_uidKey);
//     clearToken();
//   }
//
//   static Future<void> saveEmail(String email) async {
//     await _storage.write('email', email);
//   }
//
//   static String? getEmail() {
//     return _storage.read<String>('email');
//   }
//
//   static Future<void> clearEmail() async {
//     await _storage.remove('email');
//   }
//
//   static Future<void> saveIsTermsAccepted(bool response) async {
//     await _storage.write('isTermsAccepted', response);
//   }
//
//   static bool getIsTermsAccepted() {
//     return _storage.read<bool>('isTermsAccepted') ?? false;
//   }
//
//   static Future<void> clearIsTermsAccepted() async {
//     await _storage.remove('isTermsAccepted');
//   }
//
//   static Future<void> saveIsAcceptedNotification(bool response) async {
//     await _storage.write('isAcceptedNotification', response);
//   }
//
//   static bool getIsAcceptedNotification() {
//     return _storage.read<bool>('isAcceptedNotification') ?? false;
//   }
//
//   static Future<void> removeIsAcceptedNotification() async {
//     await _storage.remove('isAcceptedNotification');
//   }
//
//   static Future<void> saveNotificationState(String raceId, Map<String, bool> state) async {
//     await _storage.write('notif_$raceId', json.encode(state));
//   }
//
//   static Map<String, bool> getNotificationState(String raceId) {
//     final stateString = _storage.read<String>('notif_$raceId');
//     if (stateString != null) {
//       final stateMap = json.decode(stateString) as Map<String, dynamic>;
//       return {
//         '8hour': stateMap['8hour'] ?? false,
//         '3hour': stateMap['3hour'] ?? false,
//         '6hour': stateMap['6hour'] ?? false,
//       };
//     }
//     return {'8hour': false, '3hour': false, '6hour': false};
//   }
//
//   static Future<void> saveToken(String token) async {
//     await _storage.write('token', token);
//     final tokenn=getToken();
//     print("tokenn $tokenn");
//   }
//
//   static String? getToken() {
//     return _storage.read<String>('token');
//   }
//
//   static Future<void> clearToken() async {
//     await _storage.remove('token');
//   }
//
//   static Future<void> saveNotification({required int raceId, required int hour}) async {
//     await _storage.write('$raceId$hour', "active");
//   }
//
//   static bool getNotification({required int raceId, required int hour}) {
//     final notificationValue = _storage.read<String>('$raceId$hour');
//     return notificationValue == "active";
//   }
//
//   static Future<void> clearNotification({required int raceId, required int hour}) async {
//     await _storage.remove('$raceId$hour');
//   }
//
//   // Additional utility methods
//   static Future<void> clearAll() async {
//     await _storage.erase();
//   }
//
//   static bool hasData(String key) {
//     return _storage.hasData(key);
//   }
//
//   static Future<void> saveInt(String key, int value) async {
//     await _storage.write(key, value);
//   }
//
//   static int getInt(String key, [int defaultValue = 0]) {
//     return _storage.read<int>(key) ?? defaultValue;
//   }
//
//   static Future<void> saveDouble(String key, double value) async {
//     await _storage.write(key, value);
//   }
//
//   static double getDouble(String key, [double defaultValue = 0.0]) {
//     return _storage.read<double>(key) ?? defaultValue;
//   }
//
//   static Future<void> saveBool(String key, bool value) async {
//     await _storage.write(key, value);
//   }
//
//   static bool getBool(String key, [bool defaultValue = false]) {
//     return _storage.read<bool>(key) ?? defaultValue;
//   }
//
//   static Future<void> saveList(String key, List<dynamic> value) async {
//     await _storage.write(key, value);
//   }
//
//   static List<dynamic> getList(String key) {
//     return _storage.read<List<dynamic>>(key) ?? [];
//   }
//
//   static Future<void> saveMap(String key, Map<String, dynamic> value) async {
//     await _storage.write(key, json.encode(value));
//   }
//
//   static Map<String, dynamic> getMap(String key) {
//     final value = _storage.read<String>(key);
//     if (value != null) {
//       return Map<String, dynamic>.from(json.decode(value));
//     }
//     return {};
//   }
// }



import 'package:hive/hive.dart';

class SharedPrefHelper {
  static const String _userBoxName = 'userBox';
  static const String _settingsBoxName = 'settingsBox';
  static const String _notificationBoxName = 'notificationBox';
  static const String _uidKey = 'uid';
  static const String _emailKey = 'email';
  static const String _tokenKey = 'token';
  static const String _isTermsAcceptedKey = 'isTermsAccepted';
  static const String _isAcceptedNotificationKey = 'isAcceptedNotification';
  static const String _profileImageBox = 'profileImageBox';
  static const String _profileImagePathKey = 'profileImagePath';




  /// প্রোফাইল ইমেজ পাথ সেভ করার ফাংশন
  static Future<void> saveProfileImagePath(String? path) async {
    final box = await Hive.openBox<String>(_profileImageBox);
    if (path != null) {
      await box.put(_profileImagePathKey, path);
    } else {
      await box.delete(_profileImagePathKey); // যদি ইমেজ রিমুভ করতে চান
    }
  }

  /// সেভ করা প্রোফাইল ইমেজ পাথ পাওয়ার ফাংশন
  static Future<String?> getProfileImagePath() async {
    final box = await Hive.openBox<String>(_profileImageBox);
    return box.get(_profileImagePathKey);
  }


  // User related methods
  static Future<void> saveUid(String uid) async {
    final box = await Hive.openBox(_userBoxName);
    await box.put(_uidKey, uid);
  }

  static Future<String?> getUid() async {
    final box = await Hive.openBox(_userBoxName);
    return box.get(_uidKey);
  }

  static Future<void> clearUid() async {
    final box = await Hive.openBox(_userBoxName);
    await box.delete(_uidKey);
    await clearToken();
  }

  static Future<void> saveEmail(String email) async {
    final box = await Hive.openBox(_userBoxName);
    await box.put(_emailKey, email);
  }


  static Future<String?> getEmail() async {
    final box = await Hive.openBox(_userBoxName);
    return box.get(_emailKey);
  }

  static Future<void> clearEmail() async {
    final box = await Hive.openBox(_userBoxName);
    await box.delete(_emailKey);
  }

  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox(_userBoxName);
    await box.put(_tokenKey, token);
  }



  static Future<String?> getToken() async {
    final box = await Hive.openBox(_userBoxName);
    return box.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    final box = await Hive.openBox(_userBoxName);
    await box.delete(_tokenKey);
  }

  // Settings related methods
  static Future<void> saveIsTermsAccepted(bool response) async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_isTermsAcceptedKey, response);
  }

  static Future<bool?> getIsTermsAccepted() async {
    final box = await Hive.openBox(_settingsBoxName);
    return box.get(_isTermsAcceptedKey);
  }

  static Future<void> clearIsTermsAccepted() async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.delete(_isTermsAcceptedKey);
  }

  static Future<void> saveIsAcceptedNotification(bool response) async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put(_isAcceptedNotificationKey, response);
  }


  static Future<void> saveSubscriptionState(bool response) async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.put("subscription_state", response);
  }


  static Future<bool?> getIsAcceptedNotification() async {
    final box = await Hive.openBox(_settingsBoxName);
    return box.get(_isAcceptedNotificationKey);
  }

  static Future<bool?> getSubscriptionState() async {
    final box = await Hive.openBox(_settingsBoxName);
    return box.get("subscription_state");
  }

  static Future<void> removeIsAcceptedNotification() async {
    final box = await Hive.openBox(_settingsBoxName);
    await box.delete(_isAcceptedNotificationKey);
  }





  // Notification related methods
  static Future<void> saveNotificationState(String raceId, Map<String, bool> state) async {
    final box = await Hive.openBox(_notificationBoxName);
    await box.put('notif_$raceId', state);
  }

  static Future<Map<String, bool>> getNotificationState(String raceId) async {
    final box = await Hive.openBox(_notificationBoxName);
    final state = box.get('notif_$raceId');

    if (state != null && state is Map) {
      return {
        '8hour': state['8hour'] ?? false,
        '3hour': state['3hour'] ?? false,
        '6hour': state['6hour'] ?? false,
      };
    }
    return {'8hour': false, '3hour': false, '6hour': false};
  }

  static Future<void> saveNotification({required int raceId, required int hour}) async {
    final box = await Hive.openBox(_notificationBoxName);
    await box.put('$raceId$hour', "active");
  }

  static Future<bool> getNotification({required int raceId, required int hour}) async {
    final box = await Hive.openBox(_notificationBoxName);
    final notificationValue = box.get('$raceId$hour');

    if (notificationValue == "active") {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> clearNotification({required int raceId, required int hour}) async {
    final box = await Hive.openBox(_notificationBoxName);
    await box.delete('$raceId$hour');
  }

  // Clear all data (optional)
  static Future<void> clearAllData() async {
    final userBox = await Hive.openBox(_userBoxName);
    final settingsBox = await Hive.openBox(_settingsBoxName);
    final notificationBox = await Hive.openBox(_notificationBoxName);

    await userBox.clear();
    await settingsBox.clear();
    await notificationBox.clear();
  }
}