import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/local/preference_local_data_source.dart';
import 'package:live_bresto/data/model/profile.dart';

final profileProvider = Provider(
  (ref) => ref.watch(_profileStateProvider),
);

final preferenceRepositoryProvider = Provider((ref) {
  final preferenceLocalDataSource =
      ref.watch(preferenceLocalDataSourceProvider);
  final profileStateController = ref.watch(_profileStateProvider.notifier);
  return PreferenceRepository(
    localDataStore: preferenceLocalDataSource,
    profileStateProvider: profileStateController,
  );
});

final _profileStateProvider = StateProvider<Profile?>((ref) => null);

class PreferenceRepository {
  PreferenceRepository({
    required PreferenceLocalDataStore localDataStore,
    required StateController<Profile?> profileStateProvider,
  })  : _local = localDataStore,
        _profileStateProvider = profileStateProvider;

  final PreferenceLocalDataStore _local;
  final StateController<Profile?> _profileStateProvider;

  Future<void> ensureProfileLoaded({required Profile defaultProfile}) async {
    final profileJsonString = await _local.load(PreferenceKey.profile);
    if (profileJsonString == null) {
      _profileStateProvider.state = defaultProfile;

      await _local.save(
        PreferenceKey.profile,
        jsonEncode(defaultProfile.toJson()),
      );
      return;
    }

    final profileMap = jsonDecode(profileJsonString) as Map<String, dynamic>;
    final profile = Profile.fromJson(profileMap);

    _profileStateProvider.state = profile;
  }
}
