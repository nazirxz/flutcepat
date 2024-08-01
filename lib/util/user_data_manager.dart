import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sicepat/model/Kurir.dart';

class UserDataManager {
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Kurir.resetInstance();
    // Clear any other app-wide state or caches here
  }

  static Future<void> saveUserData(Kurir kurir) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kurirData', json.encode(kurir.toJson()));
    await prefs.setBool('isLoggedIn', true);
    Kurir.setInstance(kurir);
  }

  static Future<Kurir?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final kurirData = prefs.getString('kurirData');
    if (kurirData != null) {
      final kurirMap = json.decode(kurirData);
      final kurir = Kurir.fromJson(kurirMap);
      Kurir.setInstance(kurir);
      return kurir;
    }
    return null;
  }
}