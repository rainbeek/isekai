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
    const defaultProfile = Profile(
      icon: '👨🏻‍💼',
      name: '山田 ヒゲ太郎',
    );

    await _preferenceRepository.ensureProfileLoaded(
      defaultProfile: defaultProfile,
    );
  }
}
