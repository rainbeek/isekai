const firebaseEmulatorHost = String.fromEnvironment('FIREBASE_EMULATOR_HOST');

// TODO(ide): Productionのリリースビルドではfalseにする
const isDebugScreenAvailable = true;

final serverEnv = _getApiEnv();

// cspell:disable next
const threadIdForDebug = 'sELkOLGe1qHrasoPQpg0';

ServerEnv _getApiEnv() {
  const serverEnvString = String.fromEnvironment('FLAVOR');

  return ServerEnv.values.firstWhere(
    (value) => value.name == serverEnvString,
    orElse: () => ServerEnv.emulator,
  );
}

enum ServerEnv {
  emulator,
  dev,
}
