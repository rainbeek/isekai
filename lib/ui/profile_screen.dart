import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const name = 'ProfileScreen';

  static MaterialPageRoute route() => MaterialPageRoute<ProfileScreen>(
        builder: (_) => ProfileScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィール'),
      ),
      body: Center(
        child: Text('プロフィール'),
      ),
    );
  }
}
