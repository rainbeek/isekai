import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';
import 'package:isekai/ui/post_message_presenter.dart';
import 'package:mocktail/mocktail.dart';

class MockMessageActions extends Mock implements MessageActions {}

class MockPreferenceActions extends Mock implements PreferenceActions {}

void main() {
  late MockMessageActions mockMessageActions;
  late MockPreferenceActions mockPreferenceActions;
  late ProviderContainer container;

  setUp(() {
    mockMessageActions = MockMessageActions();
    mockPreferenceActions = MockPreferenceActions();
    container = ProviderContainer(
      overrides: [
        messageActionsProvider.overrideWithValue(mockMessageActions),
        preferenceActionsProvider.overrideWithValue(mockPreferenceActions),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('registerListeners should set the listeners', () {
    final presenter = container.read(postMessagePresenterProvider);

    Future<ConfirmResultWithDoNotShowAgainOption?> showConfirmDialog({
      required Profile profile,
    }) async {
      return null;
    }

    void close() {}

    presenter.registerListeners(
      showConfirmDialog: showConfirmDialog,
      close: close,
    );

    expect(presenter._showConfirmDialog, equals(showConfirmDialog));
    expect(presenter._close, equals(close));
  });

  test('onChangeMessage should update canPostMessageOnPostMessageScreenProvider', () {
    final presenter = container.read(postMessagePresenterProvider);

    presenter.onChangeMessage('Hello');
    expect(container.read(canPostMessageOnPostMessageScreenProvider), isTrue);

    presenter.onChangeMessage('');
    expect(container.read(canPostMessageOnPostMessageScreenProvider), isFalse);
  });

  test('sendMessage should call messageActions.sendMessage', () async {
    final presenter = container.read(postMessagePresenterProvider);

    when(() => mockPreferenceActions.getShouldExplainProfileLifecycle())
        .thenAnswer((_) async => false);
    when(() => mockMessageActions.sendMessage(text: any(named: 'text')))
        .thenAnswer((_) async {});

    presenter.registerListeners(
      showConfirmDialog: ({required Profile profile}) async {
        return null;
      },
      close: () {},
    );

    await presenter.sendMessage(text: 'Hello');

    verify(() => mockMessageActions.sendMessage(text: 'Hello')).called(1);
  });

  test('sendMessage should show confirm dialog if shouldExplainProfileLifecycle is true', () async {
    final presenter = container.read(postMessagePresenterProvider);

    when(() => mockPreferenceActions.getShouldExplainProfileLifecycle())
        .thenAnswer((_) async => true);
    when(() => mockMessageActions.sendMessage(text: any(named: 'text')))
        .thenAnswer((_) async {});

    presenter.registerListeners(
      showConfirmDialog: ({required Profile profile}) async {
        return const ConfirmResultWithDoNotShowAgainOption.doContinue(
          doNotShowAgain: true,
        );
      },
      close: () {},
    );

    await presenter.sendMessage(text: 'Hello');

    verify(() => mockMessageActions.sendMessage(text: 'Hello')).called(1);
  });
}
