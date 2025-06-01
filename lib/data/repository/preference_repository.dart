import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/local/preference_local_data_source.dart';
import 'package:isekai/data/model/profile.dart';

final Provider<Profile?> profileProvider = Provider(
  (ref) => ref.watch(_profileStateProvider),
);

final Provider<PreferenceRepository> preferenceRepositoryProvider = Provider(
  (ref) => PreferenceRepository(
    localDataStore: ref.watch(preferenceLocalDataSourceProvider),
    profileStateController: ref.watch(_profileStateProvider.notifier),
  ),
);

final _profileStateProvider = StateProvider<Profile?>((ref) => null);

class PreferenceRepository {
  PreferenceRepository({
    required PreferenceLocalDataStore localDataStore,
    required StateController<Profile?> profileStateController,
  }) : _local = localDataStore,
       _profileStateController = profileStateController;

  final PreferenceLocalDataStore _local;
  final StateController<Profile?> _profileStateController;

  Future<void> ensureInitialized() async {
    final profileJsonString = await _local.getString(PreferenceKey.profile);
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

  Future<bool?> getShouldExplainProfileLifecycle() {
    return _local.getBool(PreferenceKey.shouldExplainProfileLifecycle);
  }

  Future<void> saveShouldExplainProfileLifecycle({required bool value}) async {
    await _local.saveBool(
      PreferenceKey.shouldExplainProfileLifecycle,
      value: value,
    );
  }
}
