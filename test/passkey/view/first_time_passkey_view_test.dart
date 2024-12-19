// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passworthy/home/home.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FirstTimePasskeyView', () {
    const passkey = 'abc';
    const confirmPasskey = 'abc';

    const passkeyInputKey = Key('firstPasskeyView_passkeyInput_textField');
    const confirmPasskeyInputKey = Key(
      'firstPasskeyView_confirmPasskeyInput_textField',
    );
    const elevatedButtonKey = Key(
      'firstPasskeyView_passkeySubmit_elevatedButton',
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
            FirstTimePasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.enterText(find.byKey(passkeyInputKey), passkey);
          verify(() => passkeyBloc.add(PasskeyInputChanged(passkey))).called(1);
        },
      );

      testWidgets(
        '[ConfirmPasskeyInputChanged] when passkey input changes',
        (tester) async {
          await tester.pumpApp(
            FirstTimePasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.enterText(
            find.byKey(confirmPasskeyInputKey),
            confirmPasskey,
          );
          verify(
            () => passkeyBloc.add(ConfirmPasskeyInputChanged(confirmPasskey)),
          ).called(1);
        },
      );

      testWidgets(
        '[PasskeyInputSubmitted] when passkey submit button is pressed',
        (tester) async {
          await tester.pumpApp(
            FirstTimePasskeyView(),
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
        await tester.pumpApp(FirstTimePasskeyView(), passkeyBloc: passkeyBloc);
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
      });
    });
  });
}
