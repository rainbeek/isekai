import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/profile.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';

final preferenceActionsProvider = Provider(
  (ref) => PreferenceActions(
    preferenceRepository: ref.watch(preferenceRepositoryProvider),
    ref: ref,
  ),
);

class PreferenceActions {
  const PreferenceActions({
    required PreferenceRepository preferenceRepository,
    required Ref ref,
  })  : _preferenceRepository = preferenceRepository,
        _ref = ref;

  final PreferenceRepository _preferenceRepository;
  final Ref _ref;

  Future<void> ensureProfileLoaded() async {
    final profile = _generateRandomProfile();

    await _preferenceRepository.ensureProfileLoaded(
      defaultProfile: profile,
    );
  }

  Future<void> updateProfile() async {
    final profile = _generateRandomProfile();

    await _preferenceRepository.updateProfile(profile);
  }

  Future<void> updateProfileIfNeeded() async {
    final currentProfile = _ref.read(profileProvider);
    if (currentProfile == null) {
      return;
    }

    final current = DateTime.now();
    if (currentProfile.validUntil.isAfter(current)) {
      return;
    }

    final newProfile = _generateRandomProfile();

    await _preferenceRepository.updateProfile(newProfile);
  }

  Profile _generateRandomProfile() {
    final icon = _generateRandomIcon();
    final name = _generateRandomName();
    final validUntil = DateTime.now().add(const Duration(days: 1));

    return Profile(
      icon: icon,
      name: name,
      validUntil: validUntil,
    );
  }

  String _generateRandomIcon() {
    final rand = Random();
    final emojiValue = 0x1F600 + rand.nextInt(0x50);
    return String.fromCharCode(emojiValue);
  }

  String _generateRandomName() {
    final fakerObj = Faker();
    final firstName = fakerObj.person.firstName();
    final lastName = fakerObj.person.lastName();
    return '$firstName $lastName';
  }
}
