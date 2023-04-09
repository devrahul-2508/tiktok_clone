import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool> setUsername(String key, String? value) async =>
      await _prefs.setString(key, value!);

  static getUsername(String key) => _prefs.getString(key) ?? " ";

  static Future<bool> setEmail(String key, String? value) async =>
      await _prefs.setString(key, value!);

  static getEmail(String key) => _prefs.getString(key) ?? " ";

  static Future<bool> setLoggedInStatus(String key, bool? value) async =>
      await _prefs.setBool(key, value!);

  static getLoggedInStatus(String key) => _prefs.getBool(key) ?? false;
}
