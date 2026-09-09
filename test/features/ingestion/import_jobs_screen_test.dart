import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/instance_config.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/preferences_store.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/ingestion/data/import_job_repository.dart';
import 'package:fortuna_ui/features/ingestion/ui/import_jobs_screen.dart';

class FakeJobRepository implements ImportJobRepository {
  FakeJobRepository(this.next);

  Result<List<ImportJob>> Function() next;
  Failure<void>? retryFailure;
  final List<String> retried = [];
  int listCalls = 0;

  @override
  Future<Result<List<ImportJob>>> list() async {
    listCalls++;
    return next();
  }

  @override
  Future<Result<ImportJob>> read(String id) async =>
      const Failure(message: 'unused', kind: FailureKind.notFound);

  @override
  Future<Result<void>> retry(String id) async {
    retried.add(id);
    return retryFailure ?? const Success(null);
  }
}

ImportJob job({
  String id = 'job-1',
  JobState state = JobState.completed,
  int processed = 400,
  int imported = 397,
  int duplicates = 2,
  int rejected = 1,
  String? failureReason,
}) => ImportJob(
  id: id,
  state: state,
  processed: processed,
  imported: imported,
  duplicates: duplicates,
  rejected: rejected,
  startedAt: DateTime(2026, 9, 8, 14, 30),
  failureReason: failureReason,
);

Future<(FakeJobRepository, ProviderContainer)> pumpJobs(
  WidgetTester tester,
  Result<List<ImportJob>> Function() next, {

  /// False while a job is running: an indeterminate progress bar animates for
  /// ever by design, so `pumpAndSettle` would never return.
  bool settle = true,
}) async {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final repository = FakeJobRepository(next);
  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      preferencesStoreProvider.overrideWithValue(InMemoryPreferencesStore()),
      importJobRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ImportJobsScreen()),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  return (repository, container);
}

void main() {
  group('ImportJobsScreen', () {
    testWidgets('Given a finished import with mixed outcomes '
        'When it is shown '
        'Then imported, duplicate and rejected counts appear separately '
        '(UC-33 main flow, AF-02)', (tester) async {
      final (_, _) = await pumpJobs(tester, () => Success([job()]));

      expect(find.text('Finished'), findsOneWidget);
      expect(find.text('397'), findsOneWidget);
      expect(find.text('imported'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('skipped as duplicates'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('rejected'), findsOneWidget);

      // Never collapsed into one verdict.
      expect(
        find.textContaining('Some rows landed and some did not'),
        findsOneWidget,
      );
    });

    testWidgets('Given a running import '
        'When it is shown '
        'Then progress is indeterminate and no percentage is invented '
        '(UC-33 AF-05)', (tester) async {
      final (_, container) = await pumpJobs(
        tester,
        () => Success([job(state: JobState.running, processed: 120)]),
        settle: false,
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      // Indeterminate: the API supplies no total, so there is nothing to
      // compute a fraction from.
      expect(bar.value, isNull);

      expect(find.text('120 rows read so far'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);

      // Disposed here rather than in a tear-down, so the poll timer is gone
      // before the framework checks for pending timers.
      container.dispose();
      await tester.pump();
    });

    testWidgets('Given a failed import '
        'When it is shown '
        'Then the reason and a retry are offered (UC-33 AF-01)', (
      tester,
    ) async {
      final (_, _) = await pumpJobs(
        tester,
        () => Success([
          job(
            state: JobState.failed,
            imported: 0,
            duplicates: 0,
            rejected: 0,
            failureReason: 'The workbook could not be read.',
          ),
        ]),
      );

      expect(find.text('Failed'), findsOneWidget);
      expect(find.text('The workbook could not be read.'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Retry this import'),
        findsOneWidget,
      );
    });

    testWidgets('Given a failed import '
        'When retry is pressed '
        'Then a new job is requested and the previous one stays visible '
        '(UC-33 AF-03)', (tester) async {
      final (repository, _) = await pumpJobs(
        tester,
        () =>
            Success([job(state: JobState.failed, failureReason: 'It failed.')]),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Retry this import'));
      await tester.pumpAndSettle();

      expect(repository.retried, ['job-1']);
      // The previous outcome is still on screen: a retry that erased what
      // went wrong would take away the only evidence of why.
      expect(find.text('It failed.'), findsOneWidget);
    });

    testWidgets('Given a retry the API refuses '
        'When it is pressed '
        "Then the API's reason is shown", (tester) async {
      final (repository, _) = await pumpJobs(
        tester,
        () => Success([job(state: JobState.failed)]),
      );
      repository.retryFailure = const Failure(
        message: 'That job can no longer be retried.',
        kind: FailureKind.conflict,
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Retry this import'));
      await tester.pumpAndSettle();

      expect(find.text('That job can no longer be retried.'), findsOneWidget);
    });

    testWidgets('Given no imports '
        'When the screen settles '
        'Then an empty state explains what will appear here', (tester) async {
      final (_, _) = await pumpJobs(tester, () => const Success([]));

      expect(find.text('No imports yet'), findsOneWidget);
    });

    testWidgets('Given the jobs cannot be read '
        'When the screen settles '
        'Then the reason is shown with a retry', (tester) async {
      final (_, _) = await pumpJobs(
        tester,
        () => const Failure(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );

      expect(find.text('The instance could not be reached.'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Retry'), findsOneWidget);
    });

    testWidgets('Given only finished jobs '
        'When the screen settles '
        'Then the instance is not polled again', (tester) async {
      // Polling a static list would be noise against the instance for
      // nothing — the loop stops when nothing is running.
      final (repository, _) = await pumpJobs(
        tester,
        () => Success([job(state: JobState.completed)]),
      );

      expect(repository.listCalls, 1);

      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      expect(repository.listCalls, 1);
    });
  });

  group('JobState', () {
    test('Given a status this build does not recognize '
        'When it is mapped '
        'Then it is unknown rather than guessed at', () {
      expect(JobState.from(null), JobState.unknown);
    });

    test('Given each finished state '
        'When it is asked '
        'Then completed and failed are finished and the others are not', () {
      expect(JobState.completed.isFinished, isTrue);
      expect(JobState.failed.isFinished, isTrue);
      expect(JobState.running.isFinished, isFalse);
      expect(JobState.pending.isFinished, isFalse);
    });
  });
}
