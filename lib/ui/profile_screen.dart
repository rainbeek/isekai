import 'package:flutter/material.dart';

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
      body: const Center(
        child: Text('プロフィール'),
      ),
    );
  }
}
