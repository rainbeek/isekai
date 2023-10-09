import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/local/local_data_source.dart';
import 'package:live_bresto/data/model/profile.dart';

final preferenceRepositoryProvider = Provider((ref) {
  final preferenceLocalDataSource =
      ref.watch(preferenceLocalDataSourceProvider);
  return PreferenceRepository(localDataStore: preferenceLocalDataSource);
});

class PreferenceRepository {
  PreferenceRepository({required PreferenceLocalDataStore localDataStore})
      : _localDataStore = localDataStore;

  final PreferenceLocalDataStore _localDataStore;

  Future<void> saveProfile(Profile profile) async {
    await _localDataStore.save(
      PreferenceKey.profile,
      jsonEncode(profile.toJson()),
    );
  }
}
