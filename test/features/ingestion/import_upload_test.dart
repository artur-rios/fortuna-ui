import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/ingestion/data/file_picker_service.dart';
import 'package:fortuna_ui/features/ingestion/data/import_upload_repository.dart';
import 'package:fortuna_ui/features/ingestion/state/import_upload_controller.dart';

class FakePicker implements FilePickerService {
  FakePicker(this.next);

  /// The file the dialog returns, or null for a cancellation.
  PickedFile? Function() next;
  int calls = 0;

  @override
  Future<PickedFile?> pickFile({required List<String> extensions}) async {
    calls++;
    return next();
  }
}

class FakeUploads implements ImportUploadRepository {
  FakeUploads(this.next);

  Result<String> Function() next;
  final List<PendingUpload> uploaded = [];

  @override
  Future<Result<String>> upload(
    PendingUpload upload, {
    String? targetId,
  }) async {
    uploaded.add(upload);
    return next();
  }
}

PickedFile file(String name, {int bytes = 1024}) =>
    PickedFile(name: name, bytes: Uint8List(bytes));

({ProviderContainer container, FakePicker picker, FakeUploads uploads})
harness({
  PickedFile? Function()? picked,
  Result<String> Function()? uploadResult,
}) {
  final picker = FakePicker(picked ?? () => file('statement.xlsx'));
  final uploads = FakeUploads(uploadResult ?? () => const Success('job-1'));

  final container = ProviderContainer(
    overrides: [
      filePickerServiceProvider.overrideWithValue(picker),
      importUploadRepositoryProvider.overrideWithValue(uploads),
    ],
  );
  addTearDown(container.dispose);

  return (container: container, picker: picker, uploads: uploads);
}

void main() {
  group('ImportSource', () {
    test('Given a file name '
        'When its type is checked '
        'Then the extension decides, case-insensitively', () {
      expect(ImportSource.excel.accepts('book.xlsx'), isTrue);
      expect(ImportSource.excel.accepts('BOOK.XLSX'), isTrue);
      expect(ImportSource.excel.accepts('book.xls'), isTrue);
      expect(ImportSource.excel.accepts('book.pdf'), isFalse);
      expect(ImportSource.pdf.accepts('invoice.pdf'), isTrue);
    });

    test('Given a name with no extension at all '
        'When it is checked '
        'Then it is refused rather than treated as acceptable', () {
      expect(ImportSource.excel.accepts('book'), isFalse);
      expect(ImportSource.excel.accepts('book.'), isFalse);
      expect(ImportSource.excel.accepts(''), isFalse);
    });
  });

  group('ImportUploadController', () {
    test('Given an accepted file '
        'When it is chosen '
        'Then it is ready to send (UC-32 main flow)', () async {
      final h = harness();

      await h.container
          .read(importUploadProvider.notifier)
          .choose(ImportSource.excel);

      final state = h.container.read(importUploadProvider);
      expect(state, isA<ImportReady>());
      expect((state as ImportReady).upload.fileName, 'statement.xlsx');
    });

    test('Given the user cancels the picker '
        'When nothing is chosen '
        'Then nothing happens and no error is shown (UC-32 AF-03)', () async {
      final h = harness(picked: () => null);

      await h.container
          .read(importUploadProvider.notifier)
          .choose(ImportSource.excel);

      expect(h.container.read(importUploadProvider), isA<ImportIdle>());
    });

    test('Given a file of the wrong type '
        'When it is chosen '
        'Then it is rejected before upload, naming what is accepted '
        '(UC-32 AF-01)', () async {
      // Checked by name rather than trusting the dialog's filter, which some
      // platforms treat as a suggestion.
      final h = harness(picked: () => file('invoice.pdf'));

      await h.container
          .read(importUploadProvider.notifier)
          .choose(ImportSource.excel);

      final state = h.container.read(importUploadProvider);
      expect(state, isA<ImportRejected>());
      expect((state as ImportRejected).reason, contains('.xlsx'));
      expect(h.uploads.uploaded, isEmpty);
    });

    test(
      'Given a file over the size limit '
      'When it is chosen '
      'Then it is rejected before upload, naming the limit (UC-32 AF-02)',
      () async {
        final h = harness(
          picked: () => file('huge.xlsx', bytes: maxUploadBytes + 1),
        );

        await h.container
            .read(importUploadProvider.notifier)
            .choose(ImportSource.excel);

        final state = h.container.read(importUploadProvider);
        expect(state, isA<ImportRejected>());
        expect((state as ImportRejected).reason, contains('MB'));
        // Nothing was sent, so no long upload was wasted.
        expect(h.uploads.uploaded, isEmpty);
      },
    );

    test('Given a file exactly at the limit '
        'When it is chosen '
        'Then it is accepted — the limit is inclusive', () async {
      final h = harness(picked: () => file('big.xlsx', bytes: maxUploadBytes));

      await h.container
          .read(importUploadProvider.notifier)
          .choose(ImportSource.excel);

      expect(h.container.read(importUploadProvider), isA<ImportReady>());
    });

    test(
      'Given a ready file '
      'When it is uploaded '
      'Then the job the API started is reported (UC-32 steps 4 and 5)',
      () async {
        final h = harness();
        final controller = h.container.read(importUploadProvider.notifier);

        await controller.choose(ImportSource.excel);
        await controller.upload();

        final state = h.container.read(importUploadProvider);
        expect(state, isA<ImportStarted>());
        expect((state as ImportStarted).jobId, 'job-1');
      },
    );

    test(
      'Given the upload fails '
      'When it is reported '
      'Then the same file is kept so it can be sent again (UC-32 AF-04)',
      () async {
        final h = harness(
          uploadResult: () => const Failure(
            message: 'The upload did not complete.',
            kind: FailureKind.unreachable,
          ),
        );
        final controller = h.container.read(importUploadProvider.notifier);

        await controller.choose(ImportSource.excel);
        await controller.upload();

        final state = h.container.read(importUploadProvider);
        expect(state, isA<ImportFailed>());
        final failed = state as ImportFailed;
        expect(failed.reason, 'The upload did not complete.');
        // Making the user find the file a second time is a needless cruelty.
        expect(failed.upload.fileName, 'statement.xlsx');
      },
    );

    test(
      'Given a failed upload '
      'When it is retried '
      'Then the same bytes are sent again without re-picking (UC-32 AF-04)',
      () async {
        var attempt = 0;
        final h = harness(
          uploadResult: () {
            attempt++;
            return attempt == 1
                ? const Failure<String>(
                    message: 'It failed.',
                    kind: FailureKind.unreachable,
                  )
                : const Success('job-2');
          },
        );
        final controller = h.container.read(importUploadProvider.notifier);

        await controller.choose(ImportSource.excel);
        await controller.upload();
        await controller.upload();

        expect(h.container.read(importUploadProvider), isA<ImportStarted>());
        expect(h.uploads.uploaded, hasLength(2));
        // The picker was opened once, not twice.
        expect(h.picker.calls, 1);
      },
    );

    test('Given the API rejects the file as unreadable '
        'When it answers '
        "Then the API's reason is presented and nothing is interpreted "
        '(UC-32 AF-05)', () async {
      final h = harness(
        uploadResult: () => const Failure(
          message: 'The workbook has no recognizable header row.',
          kind: FailureKind.invalidInput,
        ),
      );
      final controller = h.container.read(importUploadProvider.notifier);

      await controller.choose(ImportSource.excel);
      await controller.upload();

      final state = h.container.read(importUploadProvider);
      expect(state, isA<ImportFailed>());
      expect(
        (state as ImportFailed).reason,
        'The workbook has no recognizable header row.',
      );
    });

    test('Given a file is uploaded '
        'When it is sent '
        'Then the bytes are unchanged (UC-32 step 3, BR-28)', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final h = harness(
        picked: () => PickedFile(name: 'book.xlsx', bytes: bytes),
      );
      final controller = h.container.read(importUploadProvider.notifier);

      await controller.choose(ImportSource.excel);
      await controller.upload();

      // The raw record is evidence, not a draft: nothing here parses,
      // transforms, filters or repairs it.
      expect(h.uploads.uploaded.single.bytes, bytes);
    });

    test('Given nothing chosen '
        'When upload is called '
        'Then it does nothing rather than sending an empty request', () async {
      final h = harness();

      await h.container.read(importUploadProvider.notifier).upload();

      expect(h.uploads.uploaded, isEmpty);
      expect(h.container.read(importUploadProvider), isA<ImportIdle>());
    });
  });
}
