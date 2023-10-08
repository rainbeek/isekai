import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/service/profile_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const name = 'ProfileScreen';

  static MaterialPageRoute<ProfileScreen> route() => MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(profile.icon, style: const TextStyle(fontSize: 48)),
            Text(profile.name, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
