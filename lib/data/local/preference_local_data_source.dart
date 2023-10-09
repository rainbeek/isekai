import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceLocalDataSourceProvider = Provider((ref) {
  return PreferenceLocalDataStore();
});

enum PreferenceKey { profile }

class PreferenceLocalDataStore {
  Future<String?> load(PreferenceKey key) async {
    final sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getString(key.name);
  }

  Future<void> save(PreferenceKey key, String value) async {
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setString(key.name, value);
  }
}
