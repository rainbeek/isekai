import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/usecase/preference_use_case.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const name = 'DebugScreen';

  static MaterialPageRoute<DebugScreen> route() => MaterialPageRoute(
        builder: (_) => const DebugScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.debug),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const _UpdateProfileTile(),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
        ],
      ),
    );
  }
}

class _UpdateProfileTile extends ConsumerWidget {
  const _UpdateProfileTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferenceActions = ref.watch(preferenceActionsProvider);

    return ListTile(
      title: const Text('プロフィールを更新する'),
      onTap: preferenceActions.updateProfile,
    );
  }
}
