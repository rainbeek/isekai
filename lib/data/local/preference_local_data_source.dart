import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceLocalDataSourceProvider = Provider(
  (ref) => PreferenceLocalDataStore(),
);

enum PreferenceKey { profile, firstMessageFlag }

class PreferenceLocalDataStore {
  Future<String?> loadString(PreferenceKey key) async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getString(key.name);
  }

  Future<void> saveString(PreferenceKey key, String value) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString(key.name, value);
  }

  Future<bool?> loadBool(PreferenceKey key) async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getBool(key.name);
  }

  Future<void> saveBool(
    PreferenceKey key, {
    required bool value,
  }) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool(key.name, value);
  }
}
