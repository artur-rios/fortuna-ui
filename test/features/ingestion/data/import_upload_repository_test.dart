import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/import_upload_repository.dart';

import '../../../support/api_stub.dart';

PendingUpload pending(ImportSource source, {String? fileName}) => PendingUpload(
  fileName:
      fileName ??
      (source == ImportSource.pdf ? 'invoice.pdf' : 'statement.xlsx'),
  bytes: Uint8List.fromList([0x50, 0x4b, 0x03, 0x04, 0x00, 0xff]),
  source: source,
);

/// The multipart body the one request carried.
FormData formOf(ApiStub stub) => stub.body! as FormData;

/// The bytes of [file], read from a copy so the original stays as sent.
Future<List<int>> bytesOf(MultipartFile file) async =>
    (await file.clone().finalize().toList()).expand((chunk) => chunk).toList();

void main() {
  group('HttpImportUploadRepository.upload', () {
    test('Given a workbook with no holding chosen '
        'When it is uploaded '
        'Then the file alone is posted, byte for byte, to the Excel import '
        '(UC-32, BR-28)', () async {
      final stub = ApiStub.data({'importJobId': 'j1'}, status: 202);
      final upload = pending(ImportSource.excel);

      final result = await HttpImportUploadRepository(stub.dio).upload(upload);

      expect(result, const Success('j1'));
      expect(stub.request.method, 'POST');
      expect(stub.request.path, '/api/imports/excel');
      final form = formOf(stub);
      expect(form.fields, isEmpty);
      final MapEntry(key: name, value: file) = form.files.single;
      expect(name, 'File');
      expect(file.filename, 'statement.xlsx');
      expect(file.length, 6);
      expect(await bytesOf(file), upload.bytes);
    });

    test('Given a workbook for a chosen holding '
        'When it is uploaded '
        'Then the holding is sent as the target', () async {
      final stub = ApiStub.data({'importJobId': 'j1'});

      await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.excel), targetId: 'a1');

      final form = formOf(stub);
      expect(form.fields.map((f) => (f.key, f.value)), [('TargetId', 'a1')]);
      expect(form.files.single.key, 'File');
    });

    test('Given an invoice for a card '
        'When it is uploaded '
        'Then it goes to the PDF import with the card named', () async {
      final stub = ApiStub.data({'importJobId': 'j1'});

      await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.pdf), targetId: 'card-1');

      expect(stub.request.path, '/api/imports/pdf');
      final form = formOf(stub);
      expect(form.fields.map((f) => (f.key, f.value)), [
        ('CreditCardId', 'card-1'),
      ]);
      expect(form.files.single.value.filename, 'invoice.pdf');
    });

    test('Given an invoice with no card chosen '
        'When it is uploaded '
        'Then no card is named', () async {
      final stub = ApiStub.data({'importJobId': 'j1'});

      await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.pdf));

      expect(formOf(stub).fields, isEmpty);
    });

    test(
      'Given an answer naming the job under another key '
      'When a file is uploaded '
      'Then the first non-empty of importJobId, jobId and id is the job',
      () async {
        Future<Result<String>> uploadAnswering(Map<String, Object?> data) =>
            HttpImportUploadRepository(ApiStub.data(data).dio)
                .upload(pending(ImportSource.excel));

        expect(
          await uploadAnswering({
            'importJobId': 'j1',
            'jobId': 'j2',
            'id': 'j3',
          }),
          const Success('j1'),
        );
        expect(
          await uploadAnswering({'importJobId': '', 'jobId': 'j2', 'id': 'j3'}),
          const Success('j2'),
        );
        expect(
          await uploadAnswering({'jobId': 7, 'id': 'j3'}),
          const Success('j3'),
        );
      },
    );

    test(
      'Given an answer that names no job '
      'When a file is uploaded '
      'Then it is a server failure rather than a success with nowhere to go',
      () async {
        const noJob = Failure<String>(
          message: 'The instance accepted the file but started no import.',
          kind: FailureKind.serverError,
        );

        for (final stub in [
          ApiStub.data({'importJobId': '', 'id': ''}),
          ApiStub.data(null),
          ApiStub.data('j1'),
          ApiStub(),
        ]) {
          final result = await HttpImportUploadRepository(stub.dio)
              .upload(pending(ImportSource.excel));

          expect(result, noJob);
        }
      },
    );

    test('Given a file the API cannot read '
        'When it is uploaded '
        "Then the API's reason is the failure (UC-32 AF-05)", () async {
      final stub = ApiStub(
        (_) => refusal(422, ['The workbook has no recognizable sheet.']),
      );

      final result = await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.excel));

      expect(
        result,
        const Failure<String>(
          message: 'The workbook has no recognizable sheet.',
          kind: FailureKind.invalidInput,
        ),
      );
    });

    test('Given a file larger than the instance takes '
        'When it is uploaded '
        "Then the API's reason is the failure (UC-32 AF-02)", () async {
      final stub = ApiStub((_) => refusal(413, ['The file is too large.']));

      final result = await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.excel));

      expect(
        result,
        const Failure<String>(
          message: 'The file is too large.',
          kind: FailureKind.serverError,
        ),
      );
    });

    test('Given an instance that cannot be reached '
        'When a file is uploaded '
        'Then it is a failure saying so (UC-32 AF-04)', () async {
      final stub = ApiStub.unreachable();

      final result = await HttpImportUploadRepository(stub.dio)
          .upload(pending(ImportSource.excel));

      expect(
        result,
        const Failure<String>(
          message: 'The instance could not be reached.',
          kind: FailureKind.unreachable,
        ),
      );
    });
  });

  group('ImportSource.acceptedTypesLabel', () {
    test('Given each source '
        'When the accepted types are named '
        'Then every extension is listed with its dot (UC-32 AF-01)', () {
      expect(ImportSource.excel.acceptedTypesLabel, '.xlsx or .xls');
      expect(ImportSource.pdf.acceptedTypesLabel, '.pdf');
    });
  });
}
