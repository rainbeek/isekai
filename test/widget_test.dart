import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';
import 'package:live_bresto/ui/root_app.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionActions extends Mock implements SessionActions {}

void main() {
  late MockSessionActions sessionActions;

  setUp(() {
    sessionActions = MockSessionActions();
  });

  testWidgets('ゲーム画面が正常に表示されること', (tester) async {
    when(sessionActions.ensureLoggedIn).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionActionsProvider.overrideWithValue(sessionActions),
        ],
        child: RootApp(),
      ),
    );
  });
}
