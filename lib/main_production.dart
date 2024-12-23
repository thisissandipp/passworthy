import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/app/app.dart';
import 'package:passworthy/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final onboardingRepository = OnboardingRepository(
    plugin: await SharedPreferences.getInstance(),
  );
  final passkeyRepository = PasskeyRepository();

  unawaited(
    bootstrap(
      () => App(
        onboardingRepository: onboardingRepository,
        passkeyRepository: passkeyRepository,
      ),
    ),
  );
}
