import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/definitions/app_mode.dart';
import 'package:live_bresto/environment_config.dart';
import 'package:live_bresto/firebase_options_dev.dart' as dev;
import 'package:live_bresto/firebase_options_emulator.dart' as emulator;
import 'package:live_bresto/ui/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseOptions firebaseOptions;
  switch (AppMode.serverEnv) {
    case ServerEnv.emulator:
      firebaseOptions = emulator.DefaultFirebaseOptions.currentPlatform;
      break;
    case ServerEnv.dev:
      firebaseOptions = dev.DefaultFirebaseOptions.currentPlatform;
      break;
  }
  await Firebase.initializeApp(options: firebaseOptions);

  if (AppMode.serverEnv == ServerEnv.emulator) {
    const firebaseEmulatorHost = EnvironmentConfig.firebaseEmulatorHost;
    await FirebaseAuth.instance.useAuthEmulator(firebaseEmulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(firebaseEmulatorHost, 8080);
  }

  runApp(
    const ProviderScope(
      child: RootApp(),
    ),
  );
}
