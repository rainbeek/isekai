import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_bresto/environment_config.dart';
import 'package:live_bresto/firebase_options_dev.dart';
import 'package:live_bresto/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const _ = EnvironmentConfig.firebaseEmulatorHost;

  runApp(const MyApp());
}
