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
  group('ExistingPasskeyPage', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(ExistingPasskeyPage());
      expect(find.byType(ExistingPasskeyView), findsOneWidget);
    });
  });

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
          when(() => passkeyBloc.state).thenReturn(PasskeyState(isValid: true));
          await tester.pumpApp(
            ExistingPasskeyView(),
            passkeyBloc: passkeyBloc,
          );

          await tester.tap(find.byKey(elevatedButtonKey));
          verify(() => passkeyBloc.add(PasskeyInputSubmitted())).called(1);
        },
      );
    });

    group('renders', () {
      testWidgets('error snackbar when submission fails', (tester) async {
        whenListen(
          passkeyBloc,
          Stream.fromIterable([
            PasskeyState(status: FormzSubmissionStatus.inProgress),
            PasskeyState(status: FormzSubmissionStatus.failure),
          ]),
        );

        await tester.pumpApp(ExistingPasskeyView(), passkeyBloc: passkeyBloc);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('error text when passkey is invalid', (tester) async {
        final passkey = MockPasskey();
        when(() => passkeyBloc.state).thenReturn(
          PasskeyState(passkey: passkey),
        );
        when(() => passkey.displayError).thenReturn(
          [PasskeyValidationError.characterLength],
        );

        await tester.pumpApp(ExistingPasskeyView(), passkeyBloc: passkeyBloc);
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
    });

    group('navigates', () {
      testWidgets('to [OverviewPage] when status is success', (tester) async {
        whenListen(
          passkeyBloc,
          Stream.fromIterable([
            PasskeyState(status: FormzSubmissionStatus.success),
          ]),
        );
        await tester.pumpApp(ExistingPasskeyView(), passkeyBloc: passkeyBloc);
        await tester.pumpAndSettle();

        expect(find.byType(OverviewPage), findsOneWidget);
      });
    });
  });
}
