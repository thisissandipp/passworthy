import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show appFlavor;
import 'package:passworthy/env/env.dart';

export 'development_env.dart';
export 'env_fields.dart';
export 'production_env.dart';
export 'staging_env.dart';

abstract interface class PassworthyEnv implements PassworthyEnvFields {
  factory PassworthyEnv() => _instance;

  /// Value of the flavor this app was built with.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  static String? passworthyAppFlavor = appFlavor;

  static PassworthyEnv get _instance => switch (passworthyAppFlavor) {
        'staging' => StagingEnv(),
        'production' => ProductionEnv(),
        _ => DevelopmentEnv(),
      };
}
