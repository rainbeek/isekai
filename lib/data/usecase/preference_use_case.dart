import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/profile.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';

final preferenceActionsProvider = Provider(
  (ref) => PreferenceActions(
    preferenceRepository: ref.watch(preferenceRepositoryProvider),
  ),
);

class PreferenceActions {
  const PreferenceActions({
    required PreferenceRepository preferenceRepository,
  }) : _preferenceRepository = preferenceRepository;

  final PreferenceRepository _preferenceRepository;

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

  Profile _generateRandomProfile() {
    final icon = _generateRandomIcon();
    final name = _generateRandomName();

    return Profile(
      icon: icon,
      name: name,
      createdAt: DateTime.now(),
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
