import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/local/preference_local_data_source.dart';
import 'package:live_bresto/data/model/profile.dart';

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

  Future<void> ensureProfileLoaded({required Profile defaultProfile}) async {
    final profileJsonString = await _local.load(PreferenceKey.profile);
    if (profileJsonString == null) {
      _profileStateController.state = defaultProfile;

      await _local.save(
        PreferenceKey.profile,
        jsonEncode(defaultProfile.toJson()),
      );
      return;
    }

    final profileMap = jsonDecode(profileJsonString) as Map<String, dynamic>;
    final profile = Profile.fromJson(profileMap);

    _profileStateController.state = profile;
  }
}
