import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template onboarding_repository}
/// A repository that manages data related to onboarding of new users.
/// {@endtemplate}
class OnboardingRepository {
  /// {@macro onboarding_repository}
  const OnboardingRepository({
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  final SharedPreferences _plugin;

  /// The key used for storing the passkey locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers.
  @visibleForTesting
  static const String kFirstTimeUserKey = '__first_time_user__';

  /// Checks if the user is a first time user. Return true for first
  /// time users.
  bool isFirstTimeUser() {
    return _plugin.getBool(kFirstTimeUserKey) ?? true;
  }

  /// Sets the current user as onboarded. From the next time, the user
  /// will be considered as existing user.
  Future<bool> setOnboarded() async {
    return _plugin.setBool(kFirstTimeUserKey, false);
  }
}
