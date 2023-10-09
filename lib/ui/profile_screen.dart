import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/repository/preference_repository.dart';
import 'debug_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const name = 'ProfileScreen';

  static MaterialPageRoute<ProfileScreen> route() => MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const _ProfilePanel(),
            ListTile(
              title: const Text('Debug screen'),
              onTap: () => Navigator.push(context, DebugScreen.route()),
            ),
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

    return ListTile(
      leading:
          Text(profile.icon, style: Theme.of(context).textTheme.headlineLarge),
      title: Text(profile.name),
    );
  }
}
