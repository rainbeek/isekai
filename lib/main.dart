import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/definitions/app_mode.dart';
import 'package:isekai/firebase_options_dev.dart' as dev;
import 'package:isekai/firebase_options_emulator.dart' as emulator;
import 'package:isekai/ui/root_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseOptions firebaseOptions;
  switch (serverEnv) {
    case ServerEnv.emulator:
      firebaseOptions = emulator.DefaultFirebaseOptions.currentPlatform;
      break;
    case ServerEnv.dev:
      firebaseOptions = dev.DefaultFirebaseOptions.currentPlatform;
      break;
  }
  await Firebase.initializeApp(options: firebaseOptions);

  if (serverEnv == ServerEnv.emulator) {
    await FirebaseAuth.instance.useAuthEmulator(firebaseEmulatorHost, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(firebaseEmulatorHost, 8080);
  }

  runApp(
    const ProviderScope(
      child: RootApp(),
    ),
  );
}
