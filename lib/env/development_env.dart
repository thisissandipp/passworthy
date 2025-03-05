import 'package:envied/envied.dart';
import 'package:passworthy/env/env.dart';

part 'development_env.g.dart';

@Envied(path: '.env.development', obfuscate: true)
final class DevelopmentEnv implements PassworthyEnv, PassworthyEnvFields {
  @override
  @EnviedField(varName: 'OBJECTBOX_STORE_DIRECTORY_PATH')
  final String kObjectBoxStoreDirectoryPath =
      _DevelopmentEnv.kObjectBoxStoreDirectoryPath;

  @override
  @EnviedField(varName: 'PASSKEY_STORAGE_KEY')
  final String kPasskeyStorageKey = _DevelopmentEnv.kPasskeyStorageKey;
}
