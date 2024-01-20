// shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferencesService?> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  // Example: save user ID to shared preferences
  Future<void> saveUserId(String userId) async {
    await _preferences!.setString('user_id', userId);
  }

  // Example: retrieve user ID from shared preferences
  String getUserId() {
    return _preferences!.getString('user_id') ?? '';
  }
}
