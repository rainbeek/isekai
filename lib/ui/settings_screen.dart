import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/definition/app_mode.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/ui/debug_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const name = 'SettingsScreen';

  static MaterialPageRoute<SettingsScreen> route() => MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    final debugTile = ListTile(
      leading: const Icon(Icons.bug_report),
      title: Text(S.of(context)!.debug),
      onTap: () => Navigator.push(context, DebugScreen.route()),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.settings),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const _ProfilePanel(),
            const SizedBox(height: 32),
            if (isDebugScreenAvailable) debugTile,
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
          ],
        ),
      ),
    );
  }
}

class _ProfilePanel extends ConsumerWidget {
  const _ProfilePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile == null) {
      return const CircularProgressIndicator();
    }

    final validUntil = profile.validUntil;

    return ListTile(
      leading:
          Text(profile.icon, style: Theme.of(context).textTheme.headlineLarge),
      title: Text(profile.name),
      subtitle: Text(
        S.of(context)!.thisProfileContinuesToFormat(validUntil, validUntil),
      ),
    );
  }
}
