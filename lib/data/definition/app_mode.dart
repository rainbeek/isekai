import 'package:isekai/data/model/thread.dart';

const firebaseEmulatorHost = String.fromEnvironment('FIREBASE_EMULATOR_HOST');

// TODO(ide): Productionのリリースビルドではfalseにする
const isDebugScreenAvailable = true;

final serverEnv = _getApiEnv();

// cspell:disable next
const threadIdForDebug = 'sELkOLGe1qHrasoPQpg0';
const threadForDebug = Thread(title: 'Default thread for debugging');

ServerEnv _getApiEnv() {
  const serverEnvString = String.fromEnvironment('FLAVOR');
  print('ServerEnv: $serverEnvString');

  return ServerEnv.values.firstWhere(
    (value) => value.name == serverEnvString,
    orElse: () => ServerEnv.emulator,
  );
}

enum ServerEnv {
  emulator,
  dev,
}
