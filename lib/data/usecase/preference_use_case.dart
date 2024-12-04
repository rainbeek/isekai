import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:isekai/data/repository/preference_repository.dart';

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

  Future<void> ensureValidProfileLoaded() async {
    await _preferenceRepository.ensureInitialized();

    await _updateProfileIfNeeded();
  }

  Future<void> updateProfile() async {
    await _generateRandomProfileAndUpdate();
  }

  Future<void> updateProfileIfNeeded() async {
    await _updateProfileIfNeeded();
  }

  Future<void> _updateProfileIfNeeded() async {
    final profile = _ref.read(profileProvider);
    if (profile != null && profile.isValid(current: DateTime.now())) {
      return;
    }

    await _generateRandomProfileAndUpdate();
  }

  Future<void> _generateRandomProfileAndUpdate() async {
    final profile = _generateRandomProfile();

    await _preferenceRepository.updateProfile(profile);
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

  Future<bool> loadFirstMessageFlag() async {
    return await _preferenceRepository.loadFirstMessageFlag() ?? false;
  }

  Future<void> saveFirstMessageFlag({required bool value}) async {
    await _preferenceRepository.saveFirstMessageFlag(value: value);
  }
}
