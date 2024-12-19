import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passkey_repository/passkey_repository.dart';
import 'package:passworthy/passkey/passkey.dart';

class MockPasskeyRepository extends Mock implements PasskeyRepository {}

class MockPasskeyBloc extends MockBloc<PasskeyEvent, PasskeyState>
    implements PasskeyBloc {}
