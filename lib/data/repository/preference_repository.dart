import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/local/preference_local_data_source.dart';
import 'package:isekai/data/model/profile.dart';

final profileProvider = Provider(
  (ref) => ref.watch(_profileStateProvider),
);

final preferenceRepositoryProvider = Provider(
  (ref) => PreferenceRepository(
    localDataStore: ref.watch(preferenceLocalDataSourceProvider),
    profileStateController: ref.watch(_profileStateProvider.notifier),
  ),
);

final _profileStateProvider = StateProvider<Profile?>(
  (ref) => null,
);

class PreferenceRepository {
  PreferenceRepository({
    required PreferenceLocalDataStore localDataStore,
    required StateController<Profile?> profileStateController,
  })  : _local = localDataStore,
        _profileStateController = profileStateController;

  final PreferenceLocalDataStore _local;
  final StateController<Profile?> _profileStateController;

  Future<void> ensureInitialized() async {
    final profileJsonString = await _local.loadString(PreferenceKey.profile);
    if (profileJsonString == null) {
      return;
    }

    final profileMap = jsonDecode(profileJsonString) as Map<String, dynamic>;
    final profile = Profile.fromJson(profileMap);

    _profileStateController.state = profile;
  }

  Future<void> updateProfile(Profile profile) async {
    _profileStateController.state = profile;

    await _local.saveString(
      PreferenceKey.profile,
      jsonEncode(profile.toJson()),
    );
  }

  Future<bool?> loadFirstMessageFlag() async {
    return _local.loadBool(PreferenceKey.firstMessageFlag);
  }

  Future<void> saveFirstMessageFlag(bool value) async {
    await _local.saveBool(PreferenceKey.firstMessageFlag, value);
  }
}
