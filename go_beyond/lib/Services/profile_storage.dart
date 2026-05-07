import 'package:shared_preferences/shared_preferences.dart';

class ProfileStorage {
  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';
  static const String _cityKey = 'profile_city';
  static const String _bioKey = 'profile_bio';

  static Future<void> saveSignupInfo({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
  }

  static Future<void> saveProfile({
    required String name,
    required String email,
    required String city,
    required String bio,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_cityKey, city);
    await prefs.setString(_bioKey, bio);
  }

  static Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString(_nameKey) ?? '',
      'email': prefs.getString(_emailKey) ?? '',
      'city': prefs.getString(_cityKey) ?? '',
      'bio': prefs.getString(_bioKey) ?? '',
    };
  }
}
