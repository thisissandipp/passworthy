import 'package:envied/envied.dart';
import 'package:passworthy/env/env.dart';

part 'production_env.g.dart';

@Envied(path: '.env.production', obfuscate: true)
final class ProductionEnv implements PassworthyEnv, PassworthyEnvFields {
  @override
  @EnviedField(varName: 'OBJECTBOX_STORE_DIRECTORY_PATH')
  final String kObjectBoxStoreDirectoryPath =
      _ProductionEnv.kObjectBoxStoreDirectoryPath;

  @override
  @EnviedField(varName: 'PASSKEY_STORAGE_KEY')
  final String kPasskeyStorageKey = _ProductionEnv.kPasskeyStorageKey;
}
