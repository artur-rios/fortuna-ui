/// Picking, checking and uploading a file (UC-32).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/file_picker_service.dart';
import '../data/import_upload_repository.dart';
import 'import_job_providers.dart';

/// Where the import screen has got to.
@immutable
sealed class ImportState {
  const ImportState();
}

/// Nothing chosen yet.
@immutable
final class ImportIdle extends ImportState {
  const ImportIdle();
}

/// A file is chosen and checked, waiting to be sent.
@immutable
final class ImportReady extends ImportState {
  const ImportReady(this.upload);

  final PendingUpload upload;
}

/// The file was rejected before it was ever sent (`AF-01`, `AF-02`).
@immutable
final class ImportRejected extends ImportState {
  const ImportRejected(this.reason);

  final String reason;
}

@immutable
final class ImportUploading extends ImportState {
  const ImportUploading(this.upload);

  final PendingUpload upload;
}

/// The upload failed. The file is kept so the same one can be sent again
/// (`AF-04`) — making the user find it a second time is a needless cruelty.
@immutable
final class ImportFailed extends ImportState {
  const ImportFailed({required this.upload, required this.reason});

  final PendingUpload upload;
  final String reason;
}

/// The API took the file and started a job.
@immutable
final class ImportStarted extends ImportState {
  const ImportStarted(this.jobId);

  final String jobId;
}

final importUploadProvider =
    NotifierProvider<ImportUploadController, ImportState>(
      ImportUploadController.new,
    );

class ImportUploadController extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportIdle();

  /// Opens the picker for [source] and checks whatever comes back.
  Future<void> choose(ImportSource source) async {
    final picked = await ref
        .read(filePickerServiceProvider)
        .pickFile(extensions: source.extensions);

    // AF-03. A cancelled picker is not an error and is not reported as one.
    if (picked == null) return;

    // AF-01. Checked by name rather than trusting the dialog's filter, which
    // some platforms treat as a suggestion.
    if (!source.accepts(picked.name)) {
      state = ImportRejected(
        '${picked.name} is not a file this source reads. '
        'Choose a ${source.acceptedTypesLabel} file.',
      );
      return;
    }

    // AF-02. Refused here rather than after a long upload.
    if (picked.bytes.length > maxUploadBytes) {
      state = ImportRejected(
        '${picked.name} is ${_megabytes(picked.bytes.length)}, and the limit '
        'is ${_megabytes(maxUploadBytes)}.',
      );
      return;
    }

    state = ImportReady(
      PendingUpload(fileName: picked.name, bytes: picked.bytes, source: source),
    );
  }

  /// Sends the chosen file, unmodified.
  Future<void> upload({String? targetId}) async {
    final upload = switch (state) {
      ImportReady(:final upload) => upload,
      ImportFailed(:final upload) => upload,
      _ => null,
    };
    if (upload == null) return;

    state = ImportUploading(upload);

    final result = await ref
        .read(importUploadRepositoryProvider)
        .upload(upload, targetId: targetId);

    switch (result) {
      case Success<String>(:final value):
        // The job is the API's now, and UC-33 follows it.
        ref.invalidate(importJobsProvider);
        state = ImportStarted(value);

      case Failure<String>(:final message):
        // AF-04, AF-05. No partial import is claimed, and the file is kept so
        // the same one can be sent again.
        state = ImportFailed(upload: upload, reason: message);
    }
  }

  /// Clears the screen back to its starting state.
  void reset() => state = const ImportIdle();

  static String _megabytes(int bytes) =>
      '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
