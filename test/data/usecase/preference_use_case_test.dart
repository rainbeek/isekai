import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_bresto/data/model/profile.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';
import 'package:live_bresto/data/usecase/preference_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../repository/mock_preference_repository.dart';

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

  ProviderContainer generateProviderContainer({
    required Override override,
  }) {
    return ProviderContainer(
      overrides: [
        preferenceRepositoryProvider.overrideWithValue(preferenceRepository),
        override,
      ],
    );
  }

  test('プロフィールが有効な場合、プロフィールが更新されない', () async {
    final current = DateTime.now();
    final container = generateProviderContainer(
      override: profileProvider.overrideWithValue(
        Profile(
          icon: '☺️',
          name: 'Test User',
          validUntil: current.add(const Duration(days: 1)),
        ),
      ),
    );
    when(() => preferenceRepository.updateProfile(any())).thenAnswer(
      (_) async => {},
    );

    await container.read(preferenceActionsProvider).updateProfileIfNeeded();

    verifyNever(() => preferenceRepository.updateProfile(any()));
  });

  test('プロフィールが無効な場合、プロフィールが更新される', () async {
    final current = DateTime.now();
    final container = generateProviderContainer(
      override: profileProvider.overrideWithValue(
        Profile(
          icon: '☺️',
          name: 'Test User',
          validUntil: current.subtract(const Duration(days: 1)),
        ),
      ),
    );
    when(() => preferenceRepository.updateProfile(any())).thenAnswer(
      (_) async => {},
    );

    await container.read(preferenceActionsProvider).updateProfileIfNeeded();

    verify(() => preferenceRepository.updateProfile(any()));
  });
}
