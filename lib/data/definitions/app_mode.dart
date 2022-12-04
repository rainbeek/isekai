class AppMode {
  static final serverEnv = _getApiEnv();

  static ServerEnv _getApiEnv() {
    const serverEnvString =
        String.fromEnvironment('SERVER_ENV', defaultValue: 'emulator');

    return ServerEnv.values.firstWhere(
      (value) => value.name == serverEnvString,
      orElse: () => ServerEnv.emulator,
    );
  }
}

enum ServerEnv {
  emulator,
  dev,
}
