import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/privacy/data/archive_saver.dart';
import 'package:fortuna_ui/features/privacy/data/personal_export_repository.dart';
import 'package:fortuna_ui/features/privacy/state/personal_export_controller.dart';

class FakeExports implements PersonalExportRepository {
  FakeExports({this.onRequest, this.onRead, this.onDownload});

  Result<PersonalExport> Function()? onRequest;
  Result<PersonalExport> Function(String jobId)? onRead;
  Result<PersonalArchive> Function(PersonalExport export)? onDownload;

  int requests = 0;
  final List<String> reads = [];
  int downloads = 0;

  @override
  Future<Result<PersonalExport>> request() async {
    requests++;
    return onRequest?.call() ?? Success(running());
  }

  @override
  Future<Result<PersonalExport>> read(String jobId) async {
    reads.add(jobId);
    return onRead?.call(jobId) ?? Success(running());
  }

  @override
  Future<Result<PersonalArchive>> download(PersonalExport export) async {
    downloads++;
    return onDownload?.call(export) ??
        Success(
          PersonalArchive(
            bytes: Uint8List.fromList([1, 2, 3]),
            fileName: 'archive.zip',
            contentType: 'application/zip',
          ),
        );
  }
}

class FakeSaver implements ArchiveSaver {
  FakeSaver(this.answer);

  Result<String> Function(PersonalArchive archive) answer;
  int saves = 0;

  @override
  Future<Result<String>> save(PersonalArchive archive) async {
    saves++;
    return answer(archive);
  }
}

PersonalExport running({int progress = 20}) => PersonalExport(
  jobId: 'job-1',
  status: PersonalExportStatus.running,
  progress: progress,
);

PersonalExport completed({DateTime? expiresAt}) => PersonalExport(
  jobId: 'job-1',
  status: PersonalExportStatus.completed,
  progress: 100,
  fileName: 'archive.zip',
  contentType: 'application/zip',
  expiresAt: expiresAt,
);

ProviderContainer containerWith({
  required FakeExports exports,
  FakeSaver? saver,
}) {
  final container = ProviderContainer(
    overrides: [
      personalExportRepositoryProvider.overrideWithValue(exports),
      archiveSaverProvider.overrideWithValue(
        saver ?? FakeSaver((_) => const Success('/tmp/archive.zip')),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('PersonalExportStatus.from', () {
    test('Given the contract numbers the statuses '
        'When each is mapped '
        'Then it lands on the one x-enum-varnames names', () {
      // The generated enum is positional because swagger_parser does not read
      // x-enum-varnames; the numbers are what the contract actually specifies.
      expect(
        PersonalExportStatus.from(statusOf(1)),
        PersonalExportStatus.pending,
      );
      expect(
        PersonalExportStatus.from(statusOf(2)),
        PersonalExportStatus.running,
      );
      expect(
        PersonalExportStatus.from(statusOf(3)),
        PersonalExportStatus.completed,
      );
      expect(
        PersonalExportStatus.from(statusOf(4)),
        PersonalExportStatus.failed,
      );
    });

    test('Given a status this build does not know '
        'When it is mapped '
        'Then it is unknown rather than guessed at', () {
      expect(PersonalExportStatus.from(null), PersonalExportStatus.unknown);
    });
  });

  group('PersonalExport', () {
    test('Given an archive whose expiry has passed '
        'When it is asked '
        'Then it is expired and not retrievable (UC-43 AF-02)', () {
      final export = completed(
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(export.hasExpired, isTrue);
      expect(export.isRetrievable, isFalse);
    });

    test('Given an archive still in date '
        'When it is asked '
        'Then it is retrievable', () {
      final export = completed(
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(export.hasExpired, isFalse);
      expect(export.isRetrievable, isTrue);
    });
  });

  group('PersonalExportController', () {
    test('Given a request '
        'When the API starts the job '
        'Then it is presented as running (UC-43 step 3)', () async {
      final container = containerWith(exports: FakeExports());

      await container.read(personalExportControllerProvider.notifier).request();

      expect(
        container.read(personalExportControllerProvider),
        isA<PersonalExportRunning>(),
      );
    });

    test('Given the job finishes '
        'When it is read '
        'Then the archive is ready to save', () async {
      final container = containerWith(
        exports: FakeExports(onRead: (_) => Success(completed())),
      );

      await container
          .read(personalExportControllerProvider.notifier)
          .refresh('job-1');

      expect(
        container.read(personalExportControllerProvider),
        isA<PersonalExportReady>(),
      );
    });

    test('Given the job fails '
        'When it is read '
        "Then the API's reason is presented (UC-43 AF-01)", () async {
      final container = containerWith(
        exports: FakeExports(
          onRead: (_) => const Success(
            PersonalExport(
              jobId: 'job-1',
              status: PersonalExportStatus.failed,
              progress: 40,
              failureReason: 'The archive could not be assembled.',
            ),
          ),
        ),
      );

      await container
          .read(personalExportControllerProvider.notifier)
          .refresh('job-1');

      final state = container.read(personalExportControllerProvider);
      expect(state, isA<PersonalExportFailed>());
      expect(state.message, 'The archive could not be assembled.');
    });

    test(
      'Given the archive expired before retrieval '
      'When the job is read '
      'Then it says so and a new one can be produced (UC-43 AF-02)',
      () async {
        final container = containerWith(
          exports: FakeExports(
            onRead: (_) => Success(
              completed(
                expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
              ),
            ),
          ),
        );

        await container
            .read(personalExportControllerProvider.notifier)
            .refresh('job-1');

        expect(
          container.read(personalExportControllerProvider),
          isA<PersonalExportExpired>(),
        );
      },
    );

    test('Given a ready archive '
        'When it is saved '
        'Then it is downloaded and written (UC-43 step 4)', () async {
      final exports = FakeExports(onRead: (_) => Success(completed()));
      final saver = FakeSaver((_) => const Success('/tmp/archive.zip'));
      final container = containerWith(exports: exports, saver: saver);
      final controller = container.read(
        personalExportControllerProvider.notifier,
      );

      await controller.refresh('job-1');
      await controller.save();

      expect(exports.downloads, 1);
      expect(saver.saves, 1);
      expect(
        container.read(personalExportControllerProvider),
        isA<PersonalExportSaved>(),
      );
    });

    test('Given the platform refuses the location '
        'When the save fails '
        'Then the archive is still retrievable and can be saved again '
        '(UC-43 AF-03)', () async {
      final exports = FakeExports(onRead: (_) => Success(completed()));
      var refuse = true;
      final saver = FakeSaver(
        (_) => refuse
            ? const Failure(
                message: 'That location could not be written to.',
                kind: FailureKind.forbidden,
              )
            : const Success('/elsewhere/archive.zip'),
      );
      final container = containerWith(exports: exports, saver: saver);
      final controller = container.read(
        personalExportControllerProvider.notifier,
      );

      await controller.refresh('job-1');
      await controller.save();

      final refused = container.read(personalExportControllerProvider);
      expect(refused, isA<PersonalExportSaveRefused>());
      // The point of AF-03: the archive survives a bad save location.
      expect((refused as PersonalExportSaveRefused).export.jobId, 'job-1');

      refuse = false;
      await controller.save();

      expect(
        container.read(personalExportControllerProvider),
        isA<PersonalExportSaved>(),
      );
    });

    test('Given a user who holds almost nothing '
        'When their archive is produced '
        'Then a small archive is saved, not reported as an error '
        '(UC-43 AF-05)', () async {
      final container = containerWith(
        exports: FakeExports(
          onRead: (_) => Success(completed()),
          onDownload: (_) => Success(
            PersonalArchive(
              bytes: Uint8List.fromList([1]),
              fileName: 'archive.zip',
              contentType: 'application/zip',
            ),
          ),
        ),
      );
      final controller = container.read(
        personalExportControllerProvider.notifier,
      );

      await controller.refresh('job-1');
      await controller.save();

      final state = container.read(personalExportControllerProvider);
      expect(state, isA<PersonalExportSaved>());
      expect((state as PersonalExportSaved).sizeBytes, 1);
    });

    test('Given nothing is ready '
        'When a save is attempted '
        'Then nothing is downloaded', () async {
      final exports = FakeExports();
      final container = containerWith(exports: exports);

      await container.read(personalExportControllerProvider.notifier).save();

      expect(exports.downloads, 0);
    });
  });
}

/// A `DataExportStatus` carrying [value], however the generator named it.
DataExportStatus statusOf(int value) => DataExportStatus.fromJson(value);
