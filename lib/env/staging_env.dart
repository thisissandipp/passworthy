import 'package:envied/envied.dart';
import 'package:passworthy/env/env.dart';

part 'staging_env.g.dart';

@Envied(path: '.env.staging', obfuscate: true)
final class StagingEnv implements PassworthyEnv, PassworthyEnvFields {
  @override
  @EnviedField(varName: 'OBJECTBOX_STORE_DIRECTORY_PATH')
  final String kObjectBoxStoreDirectoryPath =
      _StagingEnv.kObjectBoxStoreDirectoryPath;

  @override
  @EnviedField(varName: 'PASSKEY_STORAGE_KEY')
  final String kPasskeyStorageKey = _StagingEnv.kPasskeyStorageKey;
}
