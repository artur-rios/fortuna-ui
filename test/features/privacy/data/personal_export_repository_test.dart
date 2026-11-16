import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/privacy/data/personal_export_repository.dart';

import '../../../support/api_stub.dart';

PersonalExport finished({String? fileName, String? contentType}) =>
    PersonalExport(
      jobId: 'x1',
      status: PersonalExportStatus.completed,
      progress: 100,
      fileName: fileName,
      contentType: contentType,
    );

void main() {
  group('HttpPersonalExportRepository.request', () {
    test('Given a user asking for their data '
        'When the export is requested '
        'Then the job the API started is returned (FR-PR-06)', () async {
      final stub = ApiStub.data({
        'jobId': 'x1',
        'status': 1,
        'progress': 0,
        'expiresAt': '2026-11-23T00:00:00Z',
      }, status: 202);

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .request();

      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/me/data-export');
      expect(stub.body, isNull);
      final export = result.valueOrNull!;
      expect(export.jobId, 'x1');
      expect(export.status, PersonalExportStatus.pending);
      expect(export.progress, 0);
      expect(export.expiresAt, DateTime.utc(2026, 11, 23));
      expect(export.fileName, isNull);
      expect(export.contentType, isNull);
      expect(export.failureReason, isNull);
    });

    test('Given an answer with every field missing '
        'When the export is requested '
        'Then the gaps read as empty, unknown and no progress', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final export = (await HttpPersonalExportRepository.fromDio(
        stub.dio,
      ).request()).valueOrNull!;

      expect(export.jobId, '');
      expect(export.status, PersonalExportStatus.unknown);
      expect(export.progress, 0);
      expect(export.expiresAt, isNull);
    });

    test('Given an answer with no data '
        'When the export is requested '
        'Then it is a server failure, not a job', () async {
      final stub = ApiStub.data(null);

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .request();

      expect(
        result,
        const Failure<PersonalExport>(
          message: 'The instance did not start an export.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an export already running '
        'When another is requested '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub(
        (_) => refusal(409, ['An export is already in progress.']),
      );

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .request();

      expect(
        result,
        const Failure<PersonalExport>(
          message: 'An export is already in progress.',
          kind: FailureKind.conflict,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the export is requested '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .request();

      expect(
        result,
        const Failure<PersonalExport>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpPersonalExportRepository.read', () {
    test('Given a finished job '
        'When it is read '
        'Then it is fetched by its id with the archive it names', () async {
      final stub = ApiStub.data({
        'jobId': 'x1',
        'status': 3,
        'progress': 100,
        'fileName': 'export.zip',
        'contentType': 'application/zip',
      });

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .read('x1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/me/data-export/x1');
      final export = result.valueOrNull!;
      expect(export.jobId, 'x1');
      expect(export.status, PersonalExportStatus.completed);
      expect(export.progress, 100);
      expect(export.fileName, 'export.zip');
      expect(export.contentType, 'application/zip');
      expect(export.expiresAt, isNull);
      expect(export.isRetrievable, isTrue);
    });

    test('Given a failed job '
        'When it is read '
        "Then the API's reason for it is kept (UC-43 AF-01)", () async {
      final stub = ApiStub.data({
        'jobId': 'x1',
        'status': 4,
        'failureReason': 'The archive could not be written.',
      });

      final export = (await HttpPersonalExportRepository.fromDio(
        stub.dio,
      ).read('x1')).valueOrNull!;

      expect(export.status, PersonalExportStatus.failed);
      expect(export.failureReason, 'The archive could not be written.');
      expect(export.isRetrievable, isFalse);
    });

    test('Given an answer with every field missing '
        'When a job is read '
        'Then it keeps the id it was read by, with no progress', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final export = (await HttpPersonalExportRepository.fromDio(
        stub.dio,
      ).read('x1')).valueOrNull!;

      expect(export.jobId, 'x1');
      expect(export.status, PersonalExportStatus.unknown);
      expect(export.progress, 0);
      expect(export.fileName, isNull);
      expect(export.contentType, isNull);
      expect(export.failureReason, isNull);
    });

    test('Given an answer with no data '
        'When a job is read '
        'Then it is a server failure', () async {
      final stub = ApiStub.data(null);

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .read('x1');

      expect(
        result,
        const Failure<PersonalExport>(
          message: 'The instance did not report the export.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given a job that is not there '
        'When it is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(404, ['Export not found.']));

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .read('x1');

      expect(
        result,
        const Failure<PersonalExport>(
          message: 'Export not found.',
          kind: FailureKind.notFound,
        ),
      );
    });
  });

  group('HttpPersonalExportRepository.download', () {
    test(
      'Given a finished export naming its archive '
      'When it is downloaded '
      'Then the bytes are asked for on its route and kept as named',
      () async {
        final stub = ApiStub(
          (_) => download([1, 2, 3, 4], contentType: 'application/zip'),
        );

        final result = await HttpPersonalExportRepository.fromDio(stub.dio)
            .download(
              finished(
                fileName: 'export.zip',
                contentType: 'application/x-zip',
              ),
            );

        expect(stub.request.method, 'GET');
        expect(stub.request.path, '/api/me/data-export/x1');
        expect(stub.request.responseType, ResponseType.bytes);
        expect(stub.request.headers['Accept'], 'application/octet-stream');
        final archive = result.valueOrNull!;
        expect(archive.bytes, [1, 2, 3, 4]);
        expect(archive.fileName, 'export.zip');
        expect(archive.contentType, 'application/x-zip');
        expect(archive.sizeBytes, 4);
      },
    );

    test('Given an export that names no file or type '
        'When it is downloaded '
        'Then the archive gets the default name and zip type', () async {
      final stub = ApiStub((_) => download([1]));

      final archive = (await HttpPersonalExportRepository.fromDio(
        stub.dio,
      ).download(finished())).valueOrNull!;

      expect(archive.fileName, 'fortuna-personal-data.zip');
      expect(archive.contentType, 'application/zip');
    });

    test('Given an archive with nothing in it '
        'When it is downloaded '
        'Then it is an empty archive, not an error (UC-43 AF-05)', () async {
      final stub = ApiStub((_) => download(const []));

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .download(finished());

      expect(result.valueOrNull!.bytes, isEmpty);
      expect(result.valueOrNull!.sizeBytes, 0);
    });

    test(
      'Given an archive that is no longer there '
      'When it is downloaded '
      "Then it is not found, in the API's words (UC-43 AF-02, FR-DA-14)",
      () async {
        final stub = ApiStub((_) => refusal(404, ['The archive has expired.']));

        final result = await HttpPersonalExportRepository.fromDio(stub.dio)
            .download(finished());

        expect(
          result,
          const Failure<PersonalArchive>(
            message: 'The archive has expired.',
            kind: FailureKind.notFound,
          ),
        );
      },
    );

    test('Given an instance that cannot be reached '
        'When an archive is downloaded '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpPersonalExportRepository.fromDio(stub.dio)
          .download(finished());

      expect(
        result,
        const Failure<PersonalArchive>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
