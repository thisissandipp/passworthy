// Ignore below specifics for testing environment.
// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/passkey/passkey.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FirstTimePasskeyPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(FirstTimePasskeyPage());
      expect(find.byType(FirstTimePasskeyView), findsOneWidget);
    });
  });

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
          when(() => passkeyBloc.state).thenReturn(
            PasskeyState(isValid: true),
          );

          await tester.pumpApp(
            FirstTimePasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.tap(find.byKey(elevatedButtonKey));
          verify(() => passkeyBloc.add(PasskeyInputSubmitted())).called(1);
        },
      );
    });

    group('renders', () {
      for (final error in PasskeyValidationError.values) {
        testWidgets('renders error text for $error in passkey', (tester) async {
          final passkey = MockPasskey();
          when(() => passkeyBloc.state).thenReturn(
            PasskeyState(passkey: passkey),
          );
          when(() => passkey.displayError).thenReturn(
            [error],
          );

          await tester.pumpApp(
            FirstTimePasskeyView(),
            passkeyBloc: passkeyBloc,
          );
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is TextField &&
                  widget.key == passkeyInputKey &&
                  widget.decoration?.errorText != null,
            ),
            findsOneWidget,
          );
        });
      }

      testWidgets('error text when confirm passkey is invalid', (tester) async {
        final confirmPasskey = MockConfirmPasskey();
        when(() => passkeyBloc.state).thenReturn(
          PasskeyState(confirmPasskey: confirmPasskey),
        );
        when(() => confirmPasskey.displayError).thenReturn(
          ConfirmPasskeyValidationError.invalid,
        );

        await tester.pumpApp(FirstTimePasskeyView(), passkeyBloc: passkeyBloc);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                widget.key == confirmPasskeyInputKey &&
                widget.decoration?.errorText != null,
          ),
          findsOneWidget,
        );
      });
    });

    group('navigates', () {
      testWidgets('to [OverviewPage] when status is success', (tester) async {
        whenListen(
          passkeyBloc,
          Stream.fromIterable([
            PasskeyState(status: FormzSubmissionStatus.success),
          ]),
        );
        await tester.pumpApp(FirstTimePasskeyView(), passkeyBloc: passkeyBloc);
        await tester.pumpAndSettle();

        expect(find.byType(OverviewPage), findsOneWidget);
      });
    });
  });
}
