import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/definitions/app_mode.dart';
import 'package:live_bresto/data/model/profile.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';
import 'package:live_bresto/data/service/database_service.dart';

final currentThreadMessagesProvider = StreamProvider((ref) {
  return ref.watch(threadMessagesProvider(threadIdForDebug).stream);
});

final preferenceActionsProvider = Provider(
  (ref) {
    final preferenceRepository = ref.watch(preferenceRepositoryProvider);

    return PreferenceActions(
      preferenceRepository: preferenceRepository,
    );
  },
);

class PreferenceActions {
  const PreferenceActions({
    required PreferenceRepository preferenceRepository,
  }) : _preferenceRepository = preferenceRepository;

  final PreferenceRepository _preferenceRepository;

  Future<void> ensureInitialized() async {
    const defaultProfile = Profile(
      icon: '👨🏻‍💼',
      name: '山田 ヒゲ太郎',
    );

    await _preferenceRepository.ensureInitialized(
      defaultProfile: defaultProfile,
    );
  }
}
