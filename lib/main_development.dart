import 'dart:async';

import 'package:cache/cache.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:objectbox_entries_api/objectbox_entries_api.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/bootstrap.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cacheClient = CacheClient();
  final appsDirectory = await path_provider.getApplicationDocumentsDirectory();

  final entriesApi = await ObjectboxEntriesApi.init(
    storeDirectory: path.join(appsDirectory.path, 'passworthy-dir-dev'),
    cacheClient: cacheClient,
  );

  final onboardingRepository = OnboardingRepository(
    plugin: await SharedPreferences.getInstance(),
  );

  final passkeyRepository = PasskeyRepository(cacheClient: cacheClient);
  final entriesRepository = EntriesRepository(
    entriesApi: entriesApi,
  );

  unawaited(
    bootstrap(
      () => App(
        onboardingRepository: onboardingRepository,
        passkeyRepository: passkeyRepository,
        entriesRepository: entriesRepository,
      ),
    ),
  );
}
