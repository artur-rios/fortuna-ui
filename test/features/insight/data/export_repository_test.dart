import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/insight/data/export_repository.dart';

import '../../../support/api_stub.dart';

/// [bytes] with exactly the [headers] given, for the answers `download(...)`
/// cannot shape: no content type at all, or a `Content-Disposition` of the
/// instance's own wording.
ResponseBody bytesWith(List<int> bytes, Map<String, List<String>> headers) =>
    ResponseBody.fromBytes(bytes, 200, headers: headers);

/// [body] encoded as JSON bytes under [contentType], the way the export route
/// answers a queued job.
ResponseBody queuedAnswer(
  Object? body, {
  String contentType = 'application/json; charset=utf-8',
}) => bytesWith(utf8.encode(jsonEncode(body)), {
  Headers.contentTypeHeader: [contentType],
});

const csvBytes = [0x61, 0x2c, 0x62, 0x0a];

Map<String, Object?> exportOutput({int? status, int? format}) => {
  'id': 'e1',
  'status': ?status,
  'format': ?format,
};

DataExport export({String? fileName, ExportFormat format = ExportFormat.csv}) =>
    DataExport(
      id: 'e1',
      state: ExportState.completed,
      format: format,
      fileName: fileName,
    );

HttpExportRepository repositoryOn(ApiStub stub) =>
    HttpExportRepository.fromDio(stub.dio);

Future<Result<ExportOutcome>> requestCsv(ApiStub stub) => repositoryOn(stub)
    .request(recordSet: 'transactions', format: ExportFormat.csv, filters: []);

void main() {
  group('HttpExportRepository.request', () {
    test(
      'Given a scope the user confirmed '
      'When the export is asked for '
      'Then the record set, format and filters are posted for bytes back',
      () async {
        final stub = ApiStub((_) => download(csvBytes));

        await repositoryOn(stub).request(
          recordSet: 'transactions',
          format: ExportFormat.excel,
          displayCurrencyCode: 'BRL',
          locale: 'pt-BR',
          filters: const [
            ExportFilter(
              field: 'categoryId',
              operator: 'eq',
              value: 'c1',
              description: 'Category is Groceries',
            ),
          ],
        );

        expect(stub.request.method, 'POST');
        expect(stub.request.path, '/api/exports');
        expect(stub.request.responseType, ResponseType.bytes);
        expect(jsonDecode(jsonEncode(stub.body)), {
          'columns': null,
          'displayCurrencyCode': 'BRL',
          'filters': [
            {'field': 'categoryId', 'operator': 'eq', 'value': 'c1'},
          ],
          'format': 'excel',
          'locale': 'pt-BR',
          'recordSet': 'transactions',
          'sorts': null,
        });
      },
    );

    test(
      'Given an export the instance produced there and then '
      'When it is asked for '
      "Then it is the file, under the instance's own name and type",
      () async {
        final stub = ApiStub(
          (_) => download(
            csvBytes,
            contentType: 'text/csv',
            fileName: 'transactions-2026.csv',
          ),
        );

        final outcome = (await requestCsv(stub)).valueOrNull;

        final file = (outcome! as ExportDelivered).file;
        expect(file.bytes, csvBytes);
        expect(file.sizeBytes, 4);
        expect(file.fileName, 'transactions-2026.csv');
        expect(file.contentType, 'text/csv');
      },
    );

    test('Given a delivery that names no file '
        'When it is read '
        'Then the file is named after the format', () async {
      final stub = ApiStub(
        (_) => download(csvBytes, contentType: 'application/pdf'),
      );

      final outcome = (await repositoryOn(stub).request(
        recordSet: 'transactions',
        format: ExportFormat.pdf,
        filters: const [],
      )).valueOrNull;

      expect((outcome! as ExportDelivered).file.fileName, 'export.pdf');
    });

    test('Given a delivery that states no content type '
        'When it is read '
        "Then the format's own type stands in", () async {
      final stub = ApiStub((_) => bytesWith(csvBytes, const {}));

      final outcome = (await requestCsv(stub)).valueOrNull;

      expect(outcome, isA<ExportDelivered>());
      expect((outcome! as ExportDelivered).file.contentType, 'text/csv');
    });

    test('Given a content type in capitals '
        'When the delivery is read '
        'Then it is kept, lower-cased', () async {
      final stub = ApiStub(
        (_) => bytesWith(csvBytes, {
          Headers.contentTypeHeader: ['TEXT/CSV'],
        }),
      );

      final outcome = (await requestCsv(stub)).valueOrNull;

      expect((outcome! as ExportDelivered).file.contentType, 'text/csv');
    });

    test('Given a file name the instance did not quote '
        'When the delivery is read '
        'Then the name is still taken from it', () async {
      final stub = ApiStub(
        (_) => bytesWith(csvBytes, {
          Headers.contentTypeHeader: ['text/csv'],
          'content-disposition': ['attachment; filename=march.csv; size=4'],
        }),
      );

      final outcome = (await requestCsv(stub)).valueOrNull;

      expect((outcome! as ExportDelivered).file.fileName, 'march.csv');
    });

    test('Given a disposition that carries no file name '
        'When the delivery is read '
        'Then the file is named after the format', () async {
      final stub = ApiStub(
        (_) => bytesWith(csvBytes, {
          Headers.contentTypeHeader: ['text/csv'],
          'content-disposition': ['inline'],
        }),
      );

      final outcome = (await requestCsv(stub)).valueOrNull;

      expect((outcome! as ExportDelivered).file.fileName, 'export.csv');
    });

    test(
      'Given an export the instance took as a job '
      'When it is asked for '
      'Then it is queued under the id the envelope carries (UC-39 AF-05)',
      () async {
        final stub = ApiStub(
          (_) => queuedAnswer(
            envelope({
              'exportId': 'e1',
              'fileName': 'transactions.csv',
              'rowCount': 120000,
            }),
          ),
        );

        final outcome = (await requestCsv(stub)).valueOrNull;

        final export = (outcome! as ExportQueued).export;
        expect(export.id, 'e1');
        expect(export.state, ExportState.pending);
        expect(export.format, ExportFormat.csv);
        expect(export.fileName, 'transactions.csv');
        expect(export.rowCount, 120000);
        expect(export.isReady, isFalse);
      },
    );

    test('Given a job answered outside the envelope, naming a job id '
        'When it is read '
        'Then the job id is what it is followed by', () async {
      final stub = ApiStub((_) => queuedAnswer({'jobId': 'j1'}));

      final outcome = (await requestCsv(stub)).valueOrNull;

      final export = (outcome! as ExportQueued).export;
      expect(export.id, 'j1');
      expect(export.fileName, isNull);
      expect(export.rowCount, isNull);
    });

    test(
      'Given a job answer this client cannot read '
      'When it is read '
      'Then the export is queued with no identifier rather than failing',
      () async {
        final stub = ApiStub(
          (_) => bytesWith(utf8.encode('{not json'), {
            Headers.contentTypeHeader: ['application/json'],
          }),
        );

        final outcome = (await requestCsv(stub)).valueOrNull;

        final export = (outcome! as ExportQueued).export;
        expect(export.id, '');
        expect(export.state, ExportState.pending);
      },
    );

    test('Given a job answer that is not an object '
        'When it is read '
        'Then the export is queued with no identifier', () async {
      final stub = ApiStub((_) => queuedAnswer(['e1']));

      final outcome = (await requestCsv(stub)).valueOrNull;

      expect((outcome! as ExportQueued).export.id, '');
    });

    test('Given an answer with nothing in it '
        'When the export is asked for '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub();

      final result = await requestCsv(stub);

      expect(
        result,
        const Failure<ExportOutcome>(
          message: 'The instance produced nothing.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test(
      'Given a format the instance does not produce for the data set '
      'When the export is asked for '
      "Then it is refused as invalid, in the API's words (UC-39 AF-06)",
      () async {
        final stub = ApiStub(
          (_) => refusal(422, ['PDF is not available for this record set.']),
        );

        final result = await requestCsv(stub);

        expect(
          result,
          const Failure<ExportOutcome>(
            message: 'PDF is not available for this record set.',
            kind: FailureKind.invalidInput,
          ),
        );
      },
    );

    test('Given an instance that cannot be reached '
        'When the export is asked for '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await requestCsv(stub);

      expect(
        result,
        const Failure<ExportOutcome>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('HttpExportRepository.read', () {
    test('Given a completed export '
        'When its progress is read '
        'Then the record is fetched by its id and mapped', () async {
      final stub = ApiStub.data({
        'id': 'e1',
        'status': 3,
        'format': 2,
        'fileName': 'transactions.xls',
        'rowCount': 340,
        'expiresAt': '2026-11-20T12:00:00.000',
      });

      final result = await repositoryOn(stub).read('e1');

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/exports/e1');
      final export = result.valueOrNull!;
      expect(export.id, 'e1');
      expect(export.state, ExportState.completed);
      expect(export.isReady, isTrue);
      expect(export.format, ExportFormat.excel);
      expect(export.fileName, 'transactions.xls');
      expect(export.rowCount, 340);
      expect(export.failureReason, isNull);
      expect(export.expiresAt, DateTime(2026, 11, 20, 12));
    });

    test('Given an export the instance could not produce '
        'When its progress is read '
        "Then the API's own reason is kept (UC-39 AF-02)", () async {
      final stub = ApiStub.data({
        'id': 'e1',
        'status': 4,
        'format': 3,
        'failureReason': 'Too many rows for a PDF.',
      });

      final export = (await repositoryOn(stub).read('e1')).valueOrNull!;

      expect(export.state, ExportState.failed);
      expect(export.format, ExportFormat.pdf);
      expect(export.failureReason, 'Too many rows for a PDF.');
    });

    test('Given each status the API reports '
        'When an export is read '
        'Then each maps to its state, and anything else to unknown', () async {
      final expected = {
        1: ExportState.pending,
        2: ExportState.running,
        3: ExportState.completed,
        4: ExportState.failed,
        99: ExportState.unknown,
      };

      for (final MapEntry(key: wire, value: state) in expected.entries) {
        final stub = ApiStub.data(exportOutput(status: wire));

        final export = (await repositoryOn(stub).read('e1')).valueOrNull!;

        expect(export.state, state, reason: 'status $wire');
      }
    });

    test('Given each format the API reports '
        'When an export is read '
        'Then each maps to its format, and anything else to CSV', () async {
      final expected = {
        1: ExportFormat.csv,
        2: ExportFormat.excel,
        3: ExportFormat.pdf,
        4: ExportFormat.csv,
      };

      for (final MapEntry(key: wire, value: format) in expected.entries) {
        final stub = ApiStub.data(exportOutput(format: wire));

        final export = (await repositoryOn(stub).read('e1')).valueOrNull!;

        expect(export.format, format, reason: 'format $wire');
      }
    });

    test('Given an export with every optional field missing '
        'When it is read '
        'Then it keeps the id asked for and claims no state', () async {
      final stub = ApiStub.data(<String, Object?>{});

      final export = (await repositoryOn(stub).read('e9')).valueOrNull!;

      expect(export.id, 'e9');
      expect(export.state, ExportState.unknown);
      expect(export.format, ExportFormat.csv);
      expect(export.fileName, isNull);
      expect(export.rowCount, isNull);
      expect(export.failureReason, isNull);
      expect(export.expiresAt, isNull);
    });

    test('Given an answer with no data '
        'When an export is read '
        'Then it is not found', () async {
      final stub = ApiStub.data(null);

      final result = await repositoryOn(stub).read('e1');

      expect(
        result,
        const Failure<DataExport>(
          message: 'That export was not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given the API answers 404 '
        'When an export is read '
        "Then the API's reason is the failure", () async {
      final stub = ApiStub((_) => refusal(404, ['Export not found.']));

      final result = await repositoryOn(stub).read('e1');

      expect(
        result,
        const Failure<DataExport>(
          message: 'Export not found.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When an export is read '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).read('e1');

      expect((result as Failure).kind, FailureKind.unreachable);
    });
  });

  group('HttpExportRepository.download', () {
    test('Given a completed export '
        'When its file is retrieved '
        'Then the file is asked for as bytes at the record address', () async {
      final stub = ApiStub(
        (_) => download(csvBytes, contentType: 'application/vnd.ms-excel'),
      );

      final result = await repositoryOn(stub).download(
        export(fileName: 'transactions.xls', format: ExportFormat.excel),
      );

      expect(stub.request.method, 'GET');
      expect(stub.request.path, '/api/exports/e1');
      expect(stub.request.responseType, ResponseType.bytes);
      expect(stub.request.headers['Accept'], 'application/octet-stream');
      final file = result.valueOrNull!;
      expect(file.bytes, csvBytes);
      expect(file.sizeBytes, 4);
      expect(file.fileName, 'transactions.xls');
      expect(file.contentType, 'application/vnd.ms-excel');
    });

    test('Given an export with no file name and an answer with no type '
        'When its file is retrieved '
        'Then both are taken from the format', () async {
      final stub = ApiStub((_) => bytesWith(csvBytes, const {}));

      final file = (await repositoryOn(
        stub,
      ).download(export(format: ExportFormat.pdf))).valueOrNull!;

      expect(file.fileName, 'export.pdf');
      expect(file.contentType, 'application/pdf');
    });

    test('Given an answer with nothing in it '
        'When the file is retrieved '
        'Then it is a failure of the instance', () async {
      final stub = ApiStub();

      final result = await repositoryOn(stub).download(export());

      expect(
        result,
        const Failure<ExportedFile>(
          message: 'The export came back empty.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an export the instance has already discarded '
        'When its file is retrieved '
        "Then it is not found, in the API's words (UC-39 AF-04)", () async {
      final stub = ApiStub((_) => refusal(404, ['The export has expired.']));

      final result = await repositoryOn(stub).download(export());

      expect(
        result,
        const Failure<ExportedFile>(
          message: 'The export has expired.',
          kind: FailureKind.notFound,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When the file is retrieved '
        'Then it is a failure saying so', () async {
      final stub = ApiStub.unreachable();

      final result = await repositoryOn(stub).download(export());

      expect(
        result,
        const Failure<ExportedFile>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });
}
