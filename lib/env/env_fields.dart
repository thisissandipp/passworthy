/// An interface that defines all the environment variables.
///
/// DevelopmentEnv, ProductionEnv, StagingEnv must implement all these values.
abstract interface class PassworthyEnvFields {
  /// The directory path where ObjectBox will store all the uder-defined entries
  abstract final String kObjectBoxStoreDirectoryPath;

  /// The key used by Flutter Secure Storage to persist the encrypted passkey
  abstract final String kPasskeyStorageKey;
}
