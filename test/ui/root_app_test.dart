import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';
import 'package:live_bresto/ui/root_app.dart';
import 'package:mocktail/mocktail.dart';

import '../data/usecase/mock_session_use_case.dart';

void main() {
  late MockSessionActions sessionActions;

  setUp(() {
    sessionActions = MockSessionActions();
  });

  testWidgets('最初のゲーム画面が正常に表示されること', (tester) async {
    when(sessionActions.ensureLoggedIn).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionActionsProvider.overrideWithValue(sessionActions),
        ],
        child: const RootApp(),
      ),
    );
  });
}
