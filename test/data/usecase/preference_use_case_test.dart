import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_bresto/data/model/profile.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';
import 'package:live_bresto/data/usecase/preference_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockPreferenceRepository extends Mock implements PreferenceRepository {}

void main() {
  late MockPreferenceRepository preferenceRepository;

  setUp(() {
    registerFallbackValue(
      Profile(
        icon: '☺️',
        name: 'Test User',
        validUntil: DateTime.now(),
      ),
    );
    preferenceRepository = MockPreferenceRepository();
  });

  test('プロフィールが有効な場合、プロフィールが更新されない', () async {
    final current = DateTime.now();
    final container = ProviderContainer(
      overrides: [
        profileProvider.overrideWithValue(
          Profile(
            icon: '☺️',
            name: 'Test User',
            validUntil: current.add(const Duration(seconds: 1)),
          ),
        ),
        preferenceRepositoryProvider.overrideWithValue(preferenceRepository),
      ],
    );
    when(() => preferenceRepository.updateProfile(any())).thenAnswer(
      (_) async => {},
    );

    await container.read(preferenceActionsProvider).updateProfileIfNeeded();

    verifyNever(() => preferenceRepository.updateProfile(any()));
  });

  test('プロフィールが無効な場合、プロフィールが更新される', () async {
    final current = DateTime.now();
    final container = ProviderContainer(
      overrides: [
        profileProvider.overrideWithValue(
          Profile(
            icon: '☺️',
            name: 'Test User',
            validUntil: current.subtract(const Duration(seconds: 1)),
          ),
        ),
        preferenceRepositoryProvider.overrideWithValue(preferenceRepository),
      ],
    );
    when(() => preferenceRepository.updateProfile(any())).thenAnswer(
      (_) async => {},
    );

    await container.read(preferenceActionsProvider).updateProfileIfNeeded();

    verify(() => preferenceRepository.updateProfile(any()));
  });
}
