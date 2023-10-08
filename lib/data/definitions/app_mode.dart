const firebaseEmulatorHost = String.fromEnvironment('FIREBASE_EMULATOR_HOST');

final serverEnv = _getApiEnv();

// cspell:disable next
const threadIdForDebug = 'sELkOLGe1qHrasoPQpg0';

ServerEnv _getApiEnv() {
  const serverEnvString =
      String.fromEnvironment('SERVER_ENV', defaultValue: 'emulator');

  return ServerEnv.values.firstWhere(
    (value) => value.name == serverEnvString,
    orElse: () => ServerEnv.emulator,
  );
}

enum ServerEnv {
  emulator,
  dev,
}
