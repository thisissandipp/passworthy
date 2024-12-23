import 'package:bloc_test/bloc_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockPasskeyRepository extends Mock implements PasskeyRepository {}

class MockPasskeyBloc extends MockBloc<PasskeyEvent, PasskeyState>
    implements PasskeyBloc {}

class MockPasskey extends Mock implements Passkey {}

class MockConfirmPasskey extends Mock implements ConfirmPasskey {}
