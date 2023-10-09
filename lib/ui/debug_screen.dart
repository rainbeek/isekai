import 'package:flutter/material.dart';

class DebugScreen extends StatelessWidget {
  DebugScreen({Key? key}) : super(key: key);
  static const name = 'DebugScreen';

  static MaterialPageRoute<DebugScreen> route() => MaterialPageRoute(
        builder: (_) => DebugScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugging Screen'),
      ),
      body: Center(
        child: const Text('This is a debugging screen.'),
      ),
    );
  }
}
