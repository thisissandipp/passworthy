// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passworthy/home/home.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ExistingPasskeyView', () {
    const passkey = 'abcxyz';
    const passkeyInputKey = Key('existingPasskeyView_passkeyInput_textField');
    const elevatedButtonKey = Key(
      'existingPasskeyView_passkeySubmit_elevatedButton',
    );

    late PasskeyBloc passkeyBloc;

    setUp(() {
      passkeyBloc = MockPasskeyBloc();
      when(() => passkeyBloc.state).thenReturn(PasskeyState());
    });

    group('calls', () {
      testWidgets(
        '[PasskeyInputChanged] when passkey input changes',
        (tester) async {
          await tester.pumpApp(
            ExistingPasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.enterText(find.byKey(passkeyInputKey), passkey);
          verify(() => passkeyBloc.add(PasskeyInputChanged(passkey))).called(1);
        },
      );

      testWidgets(
        '[PasskeyInputSubmitted] when passkey submit button is pressed',
        (tester) async {
          await tester.pumpApp(
            ExistingPasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.tap(find.byKey(elevatedButtonKey));
          verify(() => passkeyBloc.add(PasskeyInputSubmitted())).called(1);
        },
      );
    });

    group('navigates', () {
      testWidgets('to [HomePage] when passkey is verified', (tester) async {
        whenListen(
          passkeyBloc,
          Stream.fromIterable([
            PasskeyState(isVerified: true),
          ]),
        );
        await tester.pumpApp(ExistingPasskeyView(), passkeyBloc: passkeyBloc);
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
      });
    });
  });
}
