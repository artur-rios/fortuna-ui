import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/import_job_repository.dart';

import '../../../support/api_stub.dart';

Map<String, Object?> jobOutput({
  Object? status = 3,
  int imported = 397,
  int duplicates = 2,
  int rejected = 1,
}) => {
  'id': 'j1',
  'status': status,
  'processedCount': 400,
  'importedCount': imported,
  'duplicateCount': duplicates,
  'rejectedCount': rejected,
  'createdAt': '2026-10-09T08:30:00Z',
  'failureReason': null,
  'connectionId': 'c1',
  'sourceType': 1,
};

void main() {
  group('HttpImportJobRepository.list', () {
    test('Given more import jobs than one page holds '
        'When they are listed '
        'Then every page is read and the list is whole (UC-33)', () async {
      final stub = ApiStub((request) {
        final page = requestedPage(request);
        return paginated(
          [
            {...jobOutput(), 'id': 'p$page'},
          ],
          pageNumber: page,
          totalPages: 2,
        );
      });

      final result = await HttpImportJobRepository.fromDio(stub.dio).list();

      expect(
        [
          for (final request in stub.requests)
            request.queryParameters['PageNumber'],
        ],
        [1, 2],
      );
      expect([for (final item in result.valueOrNull!) item.id], ['p1', 'p2']);
    });

    test('Given a job the API holds '
        'When the jobs are listed '
        'Then it is fetched without filters and its counts are kept apart '
        '(UC-33 AF-02)', () async {
      final stub = ApiStub.data([jobOutput()]);

      final result = await HttpImportJobRepository.fromDio(stub.dio).list();

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/import-jobs');
      expect(stub.request.queryParameters, {'PageNumber': 1, 'PageSize': 100});
      final job = result.valueOrNull!.single;
      expect(job.id, 'j1');
      expect(job.state, JobState.completed);
      expect(job.processed, 400);
      expect(job.imported, 397);
      expect(job.duplicates, 2);
      expect(job.rejected, 1);
      expect(job.startedAt, DateTime.utc(2026, 10, 9, 8, 30));
      expect(job.failureReason, isNull);
      expect(job.connectionId, 'c1');
      expect(job.isFinished, isTrue);
      expect(job.isPartial, isTrue);
    });

    test('Given each status the API publishes '
        'When the jobs are listed '
        'Then 1 to 4 are pending, running, completed and failed, '
        'and anything else is unknown', () async {
      final stub = ApiStub.data([
        jobOutput(status: 1),
        jobOutput(status: 2),
        jobOutput(status: 3),
        jobOutput(status: 4),
        jobOutput(status: 5),
        jobOutput(status: null),
      ]);

      final result = await HttpImportJobRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull!.map((job) => job.state), [
        JobState.pending,
        JobState.running,
        JobState.completed,
        JobState.failed,
        JobState.unknown,
        JobState.unknown,
      ]);
    });

    test('Given a job with every optional field missing '
        'When it is listed '
        'Then the counts read as zero and the gaps as empty', () async {
      final stub = ApiStub.data([<String, Object?>{}]);

      final job = (await HttpImportJobRepository.fromDio(
        stub.dio,
        clock: () => DateTime(2026, 11, 16, 9, 30),
      ).list()).valueOrNull!.single;

      expect(job.id, '');
      expect(job.state, JobState.unknown);
      expect(job.processed, 0);
      expect(job.imported, 0);
      expect(job.duplicates, 0);
      expect(job.rejected, 0);
      expect(job.startedAt, DateTime(2026, 11, 16, 9, 30));
      expect(job.failureReason, isNull);
      expect(job.connectionId, isNull);
      expect(job.isFinished, isFalse);
      expect(job.isPartial, isFalse);
    });

    test('Given an answer with no data '
        'When the jobs are listed '
        'Then there are none', () async {
      final stub = ApiStub.data(null);

      final result = await HttpImportJobRepository.fromDio(stub.dio).list();

      expect(result.valueOrNull, isEmpty);
    });

    test('Given an instance that cannot be reached '
        'When the jobs are listed '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpImportJobRepository.fromDio(stub.dio).list();

      expect(
        result,
        const Failure<List<ImportJob>>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpImportJobRepository.read', () {
    test('Given a failed job '
        'When it is read '
        'Then it is fetched by its id with its reason', () async {
      final stub = ApiStub.data({
        ...jobOutput(status: 4),
        'failureReason': 'The file could not be read.',
      });

      final result = await HttpImportJobRepository.fromDio(stub.dio).read('j1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/import-jobs/j1');
      final job = result.valueOrNull!;
      expect(job.state, JobState.failed);
      expect(job.failureReason, 'The file could not be read.');
    });

    test('Given an answer with no data '
        'When a job is read '
        'Then it is not found (UC-33 AF-06)', () async {
      final stub = ApiStub.data(null);

      final result = await HttpImportJobRepository.fromDio(stub.dio).read('j1');

      expect(
        result,
        const Failure<ImportJob>(
          message: 'That import job could not be found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When a job is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(404, ['Import job not found.']));

      final result = await HttpImportJobRepository.fromDio(stub.dio).read('j1');

      expect(
        result,
        const Failure<ImportJob>(
          message: 'Import job not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpImportJobRepository.retry', () {
    test('Given a failed job '
        'When it is retried '
        'Then the retry goes to its own address (UC-33 AF-03)', () async {
      final stub = ApiStub.data({'id': 'j2'});

      final result = await HttpImportJobRepository.fromDio(stub.dio)
          .retry('j1');

      expect(result, const Success<void>(null));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/import-jobs/j1/retry');
    });

    test('Given a job that has not failed '
        'When it is retried '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['Only a failed job can be retried.']),
      );

      final result = await HttpImportJobRepository.fromDio(stub.dio)
          .retry('j1');

      expect(
        result,
        const Failure<void>(
          message: 'Only a failed job can be retried.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a job is retried '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpImportJobRepository.fromDio(stub.dio)
          .retry('j1');

      expect((result as Failure<void>).kind, FailureKind.unreachable);
    });
  });

  group('ImportJob.isPartial', () {
    ImportJob job({int imported = 0, int duplicates = 0, int rejected = 0}) =>
        ImportJob(
          id: 'j1',
          state: JobState.completed,
          processed: imported + duplicates + rejected,
          imported: imported,
          duplicates: duplicates,
          rejected: rejected,
          startedAt: DateTime(2026, 10, 9),
        );

    test('Given rows that landed alongside rows that did not '
        'When the job is asked whether it is partial '
        'Then it is, for rejections and duplicates alike (UC-33 AF-02)', () {
      expect(job(imported: 399, rejected: 1).isPartial, isTrue);
      expect(job(imported: 399, duplicates: 1).isPartial, isTrue);
    });

    test('Given every row landed, or none did '
        'When the job is asked whether it is partial '
        'Then it is not', () {
      expect(job(imported: 400).isPartial, isFalse);
      expect(job(rejected: 3, duplicates: 2).isPartial, isFalse);
    });
  });
}
