import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      body: const Center(
        child: Placeholder(),
      ),
    );
  }
}
