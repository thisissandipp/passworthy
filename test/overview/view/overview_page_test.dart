import 'package:entries_api/entries_api.dart';
import 'package:entries_repository/entries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passworthy/create/create.dart';
import 'package:passworthy/overview/overview.dart';
import 'package:passworthy/settings/settings.dart';

import '../../helpers/helpers.dart';

void main() {
  group('OverviewPage', () {
    final entries = [
      Entry(
        platform: 'platform 1',
        identity: 'identity 1',
        password: 'password 1',
        createdAt: DateTime.now(),
      ),
      Entry(
        platform: 'platform 2',
        identity: 'identity 2',
        password: 'password 2',
        createdAt: DateTime.now(),
      ),
    ];

    late EntriesRepository entriesRepository;
    late OverviewBloc overviewBloc;
    late OverviewState overviewState;

    setUp(() {
      entriesRepository = MockEntriesRepository();
      overviewBloc = MockOverviewBloc();
      overviewState = MockOverviewState();

      when(() => entriesRepository.entriesCount()).thenReturn(12);
      when(() => overviewState.entries).thenReturn(entries);
      when(() => overviewBloc.state).thenReturn(overviewState);
    });

    group('renders', () {
      testWidgets('[OverviewVoew]', (tester) async {
        await tester.pumpApp(const OverviewPage());
        expect(find.byType(OverviewView), findsOneWidget);
      });

      testWidgets('all the entries', (tester) async {
        await tester.pumpApp(const OverviewView(), overviewBloc: overviewBloc);
        expect(find.byType(EntryComponent), findsNWidgets(2));
      });
    });

    group('routes', () {
      testWidgets(
        'to [SettingsPage] on clicking appbar action',
        (tester) async {
          await tester.pumpApp(
            const OverviewPage(),
            entriesRepository: entriesRepository,
          );

          final finder = find.byWidgetPredicate(
            (widget) => widget is Icon && widget.icon == Icons.settings,
          );
          expect(finder, findsOneWidget);

          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(find.byType(SettingsPage), findsOneWidget);
        },
      );

      testWidgets(
        'to [CreateEntryPage] on clicking fab',
        (tester) async {
          await tester.pumpApp(const OverviewPage());
          final finder = find.byType(FloatingActionButton);

          expect(finder, findsOneWidget);
          await tester.tap(finder);
          await tester.pumpAndSettle();

          expect(find.byType(CreateEntryPage), findsOneWidget);
        },
      );
    });

    group('shows', () {
      // testWidgets('entry details upon tapping on an entry', (tester) async {
      // ignore: lines_longer_than_80_chars
      //   await tester.pumpApp(const OverviewView(), overviewBloc: overviewBloc);
      //   await tester.tap(find.text('platform 1'));

      //   await tester.pumpAndSettle();
      //   expect(find.byType(BuildEntryDetails), findsOneWidget);
      // });

      // testWidgets(
      //   'delete confirmation dialog upon clicking delete',
      //   (tester) async {
      //     await tester.pumpApp(
      //       const OverviewView(),
      //       overviewBloc: overviewBloc,
      //     );
      //     await tester.tap(find.text('platform 1'));
      //     const deleteKey = Key('buildEntryDetails_delete_iconButton');

      //     await tester.pumpAndSettle();
      //     await tester.tap(find.byKey(deleteKey));

      //     await tester.pumpAndSettle();
      //     expect(find.byType(DeleteConfirmationDialog), findsOneWidget);
      //   },
      // );
    });
  });
}
