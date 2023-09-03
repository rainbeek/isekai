import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_bresto/data/service/auth_service.dart';
import 'package:live_bresto/ui/root_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        overrides: [
          authActionsProvider.overrideWithValue(value),
        ],
        child: RootApp(),
      ),
    );

    await tester.pumpAndSettle();
  });
}
