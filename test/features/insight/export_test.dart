import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/features/insight/data/export_repository.dart';
import 'package:fortuna_ui/features/insight/data/export_saver.dart';
import 'package:fortuna_ui/features/insight/state/export_controller.dart';
import 'package:fortuna_ui/features/insight/ui/export_sheet.dart';
import 'package:fortuna_ui/features/transactions/data/transaction_repository.dart';
import 'package:fortuna_ui/features/transactions/state/transaction_table.dart';

class FakeExports implements ExportRepository {
  FakeExports({this.onRequest, this.onRead, this.onDownload});

  Result<ExportOutcome> Function()? onRequest;
  Result<DataExport> Function()? onRead;
  Result<ExportedFile> Function()? onDownload;

  final List<Map<String, Object?>> requests = [];

  @override
  Future<Result<ExportOutcome>> request({
    required String recordSet,
    required ExportFormat format,
    required List<ExportFilter> filters,
    String? displayCurrencyCode,
    String? locale,
  }) async {
    requests.add({
      'recordSet': recordSet,
      'format': format,
      'filters': filters.map((f) => f.field).toList(),
    });
    return onRequest?.call() ?? Success(ExportDelivered(file()));
  }

  @override
  Future<Result<DataExport>> read(String exportId) async =>
      onRead?.call() ?? Success(export(state: ExportState.completed));

  @override
  Future<Result<ExportedFile>> download(DataExport export) async =>
      onDownload?.call() ?? Success(file());
}

class FakeSaver implements ExportSaver {
  FakeSaver({this.onSave});

  Result<String> Function()? onSave;

  final List<ExportedFile> saved = [];

  @override
  Future<Result<String>> save(ExportedFile file) async {
    saved.add(file);
    return onSave?.call() ?? const Success('/tmp/export.csv');
  }
}

ExportedFile file({String name = 'transactions.csv'}) => ExportedFile(
  bytes: Uint8List.fromList([1, 2, 3]),
  fileName: name,
  contentType: 'text/csv',
);

DataExport export({
  ExportState state = ExportState.pending,
  String? failureReason,
  DateTime? expiresAt,
}) => DataExport(
  id: 'e1',
  state: state,
  format: ExportFormat.csv,
  fileName: 'transactions.csv',
  failureReason: failureReason,
  expiresAt: expiresAt,
);

ProviderContainer containerWith({FakeExports? exports, FakeSaver? saver}) {
  final container = ProviderContainer(
    overrides: [
      exportRepositoryProvider.overrideWithValue(exports ?? FakeExports()),
      exportSaverProvider.overrideWithValue(saver ?? FakeSaver()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<void> pumpSheet(
  WidgetTester tester, {
  FakeExports? exports,
  FakeSaver? saver,
  bool hasData = true,
  List<ExportFilter> filters = const [],
}) async {
  tester.view.physicalSize = const Size(1000, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        exportRepositoryProvider.overrideWithValue(exports ?? FakeExports()),
        exportSaverProvider.overrideWithValue(saver ?? FakeSaver()),
        preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ExportSheet(
            recordSet: 'transactions',
            filters: filters,
            hasData: hasData,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('ExportState', () {
    test('Given the numbers the contract specifies '
        'When they are mapped '
        'Then each keeps its own meaning', () {
      expect(ExportState.pending.wire, 1);
      expect(ExportState.running.wire, 2);
      expect(ExportState.completed.wire, 3);
      expect(ExportState.failed.wire, 4);
    });

    test('Given a state this build does not recognize '
        'When it is mapped '
        'Then it is unknown rather than completed', () {
      // Guessing "completed" would offer a file that may not exist.
      expect(ExportState.from(null), ExportState.unknown);
      expect(ExportState.unknown.isFinished, isFalse);
    });

    test('Given a finished state '
        'When it is asked '
        'Then only completed and failed count', () {
      expect(ExportState.completed.isFinished, isTrue);
      expect(ExportState.failed.isFinished, isTrue);
      expect(ExportState.running.isFinished, isFalse);
    });
  });

  group('DataExport.hasExpired', () {
    final now = DateTime(2026, 9, 11, 12);

    test('Given an expiry in the future '
        'When it is asked '
        'Then it has not expired', () {
      expect(
        export(expiresAt: DateTime(2026, 9, 12)).hasExpired(now: now),
        isFalse,
      );
    });

    test('Given an expiry in the past '
        'When it is asked '
        'Then it has expired (AF-04)', () {
      expect(
        export(expiresAt: DateTime(2026, 9, 10)).hasExpired(now: now),
        isTrue,
      );
    });

    test('Given no expiry at all '
        'When it is asked '
        'Then nothing is assumed', () {
      expect(export().hasExpired(now: now), isFalse);
    });
  });

  group('describeFilters', () {
    test('Given an unfiltered view '
        'When its scope is described '
        'Then there is nothing to describe', () {
      expect(describeFilters(const TransactionView()), isEmpty);
    });

    test('Given a filtered view '
        'When its scope is described '
        'Then each filter is described in words, not identifiers '
        '(FR-EX-03)', () {
      final described = describeFilters(
        TransactionView(
          from: DateTime(2026, 9),
          to: DateTime(2026, 9, 30),
          direction: Direction.expense,
          text: 'market',
        ),
      );

      expect(described, hasLength(4));
      // The description is what the user checks the scope against, so it has
      // to read as a sentence rather than as a query.
      expect(
        described.map((f) => f.description),
        containsAll([
          'From 2026-09-01',
          'Up to 2026-09-30',
          'Expenses only',
          'Matching "market"',
        ]),
      );
    });

    test('Given a filtered view '
        'When its scope is described '
        'Then the field and operator the API needs travel alongside', () {
      final described = describeFilters(
        TransactionView(from: DateTime(2026, 9)),
      );

      expect(described.single.field, 'occurredOn');
      expect(described.single.operator, 'gte');
    });

    test('Given amount bounds '
        'When they are described '
        'Then they travel as the strings they were typed as', () {
      final described = describeFilters(
        const TransactionView(minimumAmount: '10.00', maximumAmount: '500.00'),
      );

      expect(described.first.value, '10.00');
      expect(described.last.value, '500.00');
    });
  });

  group('ExportController', () {
    test('Given a direct delivery '
        'When an export is produced '
        'Then the file is in hand (step 3)', () async {
      final container = containerWith();

      await container
          .read(exportControllerProvider.notifier)
          .produce(
            recordSet: 'transactions',
            format: ExportFormat.csv,
            filters: const [],
          );

      expect(container.read(exportControllerProvider), isA<ExportReady>());
    });

    test('Given the chosen format and filters '
        'When an export is produced '
        'Then both reach the API (FR-EX-02, FR-EX-03)', () async {
      final exports = FakeExports();

      await containerWith(exports: exports)
          .read(exportControllerProvider.notifier)
          .produce(
            recordSet: 'transactions',
            format: ExportFormat.pdf,
            filters: const [
              ExportFilter(
                field: 'categoryId',
                operator: 'eq',
                value: 'cat1',
                description: 'One category only',
              ),
            ],
          );

      expect(exports.requests.single['format'], ExportFormat.pdf);
      expect(exports.requests.single['filters'], ['categoryId']);
    });

    test('Given the API refuses '
        'When an export is produced '
        'Then its reason is what the user sees (AF-02, AF-06)', () async {
      final container = containerWith(
        exports: FakeExports(
          onRequest: () => const Failure(
            message: 'PDF is not produced for this data set.',
            kind: FailureKind.invalidInput,
          ),
        ),
      );

      await container
          .read(exportControllerProvider.notifier)
          .produce(
            recordSet: 'transactions',
            format: ExportFormat.pdf,
            filters: const [],
          );

      final state = container.read(exportControllerProvider);
      expect(state, isA<ExportFailed>());
      expect(
        (state as ExportFailed).reason,
        'PDF is not produced for this data set.',
      );
    });

    test('Given a produced file '
        'When it is saved '
        'Then it goes through the platform (step 5, FR-EX-05)', () async {
      final saver = FakeSaver();
      final container = containerWith(saver: saver);
      final controller = container.read(exportControllerProvider.notifier);

      await controller.produce(
        recordSet: 'transactions',
        format: ExportFormat.csv,
        filters: const [],
      );
      await controller.save();

      expect(saver.saved, hasLength(1));
      expect(container.read(exportControllerProvider), isA<ExportSaved>());
    });

    test('Given the platform refuses the location '
        'When the save is attempted '
        'Then the file is kept and the save offered again (AF-03)', () async {
      final container = containerWith(
        saver: FakeSaver(
          onSave: () => const Failure(
            message: 'That location could not be written to.',
            kind: FailureKind.forbidden,
          ),
        ),
      );
      final controller = container.read(exportControllerProvider.notifier);

      await controller.produce(
        recordSet: 'transactions',
        format: ExportFormat.csv,
        filters: const [],
      );
      await controller.save();

      final state = container.read(exportControllerProvider);
      // Still ready — the export did not fail, only the save did.
      expect(state, isA<ExportReady>());
      expect((state as ExportReady).saveRefusal, isNotNull);
      expect(state.file.fileName, 'transactions.csv');
    });

    test('Given an export that has expired '
        'When it is retrieved '
        'Then that is said rather than a download attempted (AF-04)', () async {
      var downloads = 0;
      final container = containerWith(
        exports: FakeExports(
          onDownload: () {
            downloads++;
            return Success(file());
          },
        ),
      );

      await container
          .read(exportControllerProvider.notifier)
          .retrieve(export(expiresAt: DateTime(2020)));

      expect(container.read(exportControllerProvider), isA<ExportExpired>());
      // Nothing was asked for: the instance has already discarded it.
      expect(downloads, 0);
    });

    test(
      'Given a queued export '
      'When it is requested '
      'Then the job is kept so leaving does not lose it (AF-05, FR-EX-04)',
      () async {
        final container = containerWith(
          exports: FakeExports(
            onRequest: () => Success(ExportQueued(export())),
          ),
        );

        await container
            .read(exportControllerProvider.notifier)
            .produce(
              recordSet: 'transactions',
              format: ExportFormat.csv,
              filters: const [],
            );

        final state = container.read(exportControllerProvider);
        expect(state, isA<ExportRunning>());
        expect((state as ExportRunning).export?.id, 'e1');

        // Stop the poller so the test does not leave a timer running.
        container.read(exportControllerProvider.notifier).reset();
      },
    );

    test('Given a produced export '
        'When the controller is reset '
        'Then it is ready to be asked again (AF-04)', () async {
      final container = containerWith();
      final controller = container.read(exportControllerProvider.notifier);

      await controller.produce(
        recordSet: 'transactions',
        format: ExportFormat.csv,
        filters: const [],
      );
      controller.reset();

      expect(container.read(exportControllerProvider), isA<ExportIdle>());
    });
  });

  group('ExportSheet', () {
    testWidgets('Given a view with no data '
        'When export is opened '
        'Then it is not offered and the reason is stated (AF-01)', (
      tester,
    ) async {
      final exports = FakeExports();

      await pumpSheet(tester, exports: exports, hasData: false);

      expect(find.byKey(const Key('export.nothingToExport')), findsOneWidget);
      expect(find.byKey(const Key('export.produce')), findsNothing);
      expect(find.textContaining('nothing in this view'), findsOneWidget);
      expect(exports.requests, isEmpty);
    });

    testWidgets('Given an unfiltered view '
        'When export is opened '
        'Then the scope says everything (step 2)', (tester) async {
      await pumpSheet(tester);

      expect(find.byKey(const Key('export.scope')), findsOneWidget);
      expect(find.byKey(const Key('export.scope.unfiltered')), findsOneWidget);
    });

    testWidgets('Given a filtered view '
        'When export is opened '
        'Then each filter is named before anything is produced (step 2, '
        'FR-EX-03)', (tester) async {
      await pumpSheet(
        tester,
        filters: const [
          ExportFilter(
            field: 'categoryId',
            operator: 'eq',
            value: 'cat1',
            description: 'One category only',
          ),
          ExportFilter(
            field: 'direction',
            operator: 'eq',
            value: '1',
            description: 'Expenses only',
          ),
        ],
      );

      expect(find.byKey(const Key('export.scope.categoryId')), findsOneWidget);
      expect(find.textContaining('One category only'), findsOneWidget);
      expect(find.textContaining('Expenses only'), findsOneWidget);
    });

    testWidgets('Given a format is chosen '
        'When the export is produced '
        'Then that format is what is asked for (step 1)', (tester) async {
      final exports = FakeExports();

      await pumpSheet(tester, exports: exports);
      await tester.tap(find.text('Excel'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pumpAndSettle();

      expect(exports.requests.single['format'], ExportFormat.excel);
    });

    testWidgets('Given a produced export '
        'When it is shown '
        'Then saving is offered (step 5)', (tester) async {
      await pumpSheet(tester);
      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.ready')), findsOneWidget);
      expect(find.byKey(const Key('export.save')), findsOneWidget);
    });

    testWidgets('Given the save is refused '
        'When it returns '
        'Then another place is offered and the file is still there (AF-03)', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        saver: FakeSaver(
          onSave: () => const Failure(
            message: 'That location could not be written to.',
            kind: FailureKind.forbidden,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('export.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.saveRefused')), findsOneWidget);
      expect(find.text('Choose another place'), findsOneWidget);
      expect(find.textContaining('still here'), findsOneWidget);
    });

    testWidgets('Given the export is saved '
        'When it completes '
        'Then where it went is shown', (tester) async {
      await pumpSheet(tester);
      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('export.save')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.saved')), findsOneWidget);
      expect(find.text('/tmp/export.csv'), findsOneWidget);
    });

    testWidgets('Given the job fails '
        'When it returns '
        "Then the API's reason is shown with a retry (AF-02)", (tester) async {
      await pumpSheet(
        tester,
        exports: FakeExports(
          onRequest: () => const Failure(
            message: 'The export could not be produced.',
            kind: FailureKind.serverError,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('export.failed')), findsOneWidget);
      expect(find.byKey(const Key('export.retry')), findsOneWidget);
      expect(find.text('The export could not be produced.'), findsOneWidget);
    });

    testWidgets('Given a queued export '
        'When it is running '
        'Then the interface says it keeps going without this screen '
        '(FR-EX-04, AF-05)', (tester) async {
      await pumpSheet(
        tester,
        exports: FakeExports(onRequest: () => Success(ExportQueued(export()))),
      );

      await tester.tap(find.byKey(const Key('export.produce')));
      await tester.pump();

      expect(find.byKey(const Key('export.running')), findsOneWidget);
      expect(
        find.byKey(const Key('export.running.keepsGoing')),
        findsOneWidget,
      );
      expect(find.textContaining('keeps going'), findsOneWidget);
      // And closing is offered rather than the interface being blocked.
      expect(find.byKey(const Key('export.running.close')), findsOneWidget);
    });
  });
}
