import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/usecase/preference_use_case.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  static const name = 'DebugScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.debug),
      ),
      body: const Center(
        child: _UpdateProfileTile(),
      ),
    );
  }

  static MaterialPageRoute<DebugScreen> route() => MaterialPageRoute(
        builder: (_) => const DebugScreen(),
        settings: const RouteSettings(name: name),
      );
}

class _UpdateProfileTile extends ConsumerWidget {
  const _UpdateProfileTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferenceActions = ref.watch(preferenceActionsProvider);

    return TextButton(
      onPressed: preferenceActions.updateProfile,
      child: const Text('プロフィールを更新する'),
    );
  }
}
