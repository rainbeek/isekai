import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/environment_config.dart';
import 'package:live_bresto/firebase_options_emulator.dart';
import 'package:live_bresto/ui/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const firebaseEmulatorHost = EnvironmentConfig.firebaseEmulatorHost;
  await FirebaseAuth.instance.useAuthEmulator(firebaseEmulatorHost, 9099);

  runApp(
    const ProviderScope(
      child: RootApp(),
    ),
  );
}
