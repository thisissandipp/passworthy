import 'package:bloc_test/bloc_test.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onboarding_repository/onboarding_repository.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/banner/banner.dart';
import 'package:passworthy/onboarding/onboarding.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/passkey/passkey.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

class MockOnboardingBloc extends MockBloc<OnboardingEvent, OnboardingState>
    implements OnboardingBloc {}

class MockPasskeyRepository extends Mock implements PasskeyRepository {}

class MockPasskeyBloc extends MockBloc<PasskeyEvent, PasskeyState>
    implements PasskeyBloc {}

class MockPasskey extends Mock implements Passkey {}

class MockConfirmPasskey extends Mock implements ConfirmPasskey {}

class MockEntriesRepository extends Mock implements EntriesRepository {}

class MockBannerCubit extends MockCubit<BannerState> implements BannerCubit {}

class MockOverviewBloc extends MockBloc<OverviewEvent, OverviewState>
    implements OverviewBloc {}

class MockOverviewState extends Mock implements OverviewState {}
