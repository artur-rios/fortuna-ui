/// The complete personal-data export (UC-43).
///
/// A job, not a request-response. The archive takes as long as it takes, and
/// `AF-04` requires that leaving the screen not cancel it — so the job id is
/// what this holds, and the work happens on the instance.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/archive_saver.dart';
import '../data/personal_export_repository.dart';

@immutable
sealed class PersonalExportState {
  const PersonalExportState();

  String? get message => switch (this) {
    PersonalExportFailed(:final reason) => reason,
    PersonalExportSaveRefused(:final reason) => reason,
    PersonalExportSaved(:final where) => 'Saved to $where.',
    _ => null,
  };
}

/// Nothing has been asked for yet.
@immutable
final class PersonalExportIdle extends PersonalExportState {
  const PersonalExportIdle();
}

/// The job is on the instance (`AF-04`: it stays there if the user leaves).
@immutable
final class PersonalExportRunning extends PersonalExportState {
  const PersonalExportRunning(this.export);

  final PersonalExport export;
}

/// Ready to retrieve.
@immutable
final class PersonalExportReady extends PersonalExportState {
  const PersonalExportReady(this.export);

  final PersonalExport export;
}

/// `AF-02`: it finished, and then the archive expired before anyone fetched it.
@immutable
final class PersonalExportExpired extends PersonalExportState {
  const PersonalExportExpired(this.export);

  final PersonalExport export;
}

/// `AF-01`: the job failed, with the API's reason and a retry.
@immutable
final class PersonalExportFailed extends PersonalExportState {
  const PersonalExportFailed(this.reason);

  final String reason;
}

/// `AF-03`: the platform would not save it there. The archive is still there.
@immutable
final class PersonalExportSaveRefused extends PersonalExportState {
  const PersonalExportSaveRefused(this.reason, this.export);

  final String reason;
  final PersonalExport export;
}

@immutable
final class PersonalExportSaved extends PersonalExportState {
  const PersonalExportSaved(this.where, this.sizeBytes);

  final String where;

  /// `AF-05`: a near-empty archive is a valid one, and the size says so
  /// without dressing it up as a problem.
  final int sizeBytes;
}

final personalExportControllerProvider =
    NotifierProvider<PersonalExportController, PersonalExportState>(
      PersonalExportController.new,
    );

class PersonalExportController extends Notifier<PersonalExportState> {
  @override
  PersonalExportState build() {
    ref.onDispose(() => _polling?.cancel());
    return const PersonalExportIdle();
  }

  Timer? _polling;

  /// Steps 1-3: ask for the archive.
  Future<void> request() async {
    final result = await ref.read(personalExportRepositoryProvider).request();

    switch (result) {
      case Success<PersonalExport>(:final value):
        state = PersonalExportRunning(value);
        _scheduleRefresh(value.jobId);

      case Failure<PersonalExport>(:final message):
        state = PersonalExportFailed(message);
    }
  }

  /// Reads where the job has got to.
  Future<void> refresh(String jobId) async {
    final result = await ref.read(personalExportRepositoryProvider).read(jobId);

    switch (result) {
      case Failure<PersonalExport>(:final message):
        state = PersonalExportFailed(message);

      case Success<PersonalExport>(:final value):
        state = switch (value.status) {
          // AF-01: the API's own reason, not a generic failure.
          PersonalExportStatus.failed => PersonalExportFailed(
            value.failureReason ?? 'The export failed.',
          ),
          // AF-02: finished, and gone before it was fetched.
          PersonalExportStatus.completed when value.hasExpired =>
            PersonalExportExpired(value),
          PersonalExportStatus.completed => PersonalExportReady(value),
          _ => PersonalExportRunning(value),
        };

        if (!value.status.isFinished) _scheduleRefresh(jobId);
    }
  }

  void _scheduleRefresh(String jobId) {
    _polling?.cancel();
    // Polled rather than pushed, and only while something is actually running:
    // a finished job is static, and asking again would be noise.
    _polling = Timer(
      const Duration(seconds: 3),
      () => unawaited(refresh(jobId)),
    );
  }

  /// Step 4: retrieve it and save it.
  Future<void> save() async {
    final current = state;
    final export = switch (current) {
      PersonalExportReady(:final export) => export,
      PersonalExportSaveRefused(:final export) => export,
      _ => null,
    };
    if (export == null) return;

    final downloaded = await ref
        .read(personalExportRepositoryProvider)
        .download(export);

    switch (downloaded) {
      case Failure<PersonalArchive>(:final message):
        state = PersonalExportFailed(message);

      case Success<PersonalArchive>(:final value):
        final archive = value;
        final saved = await ref.read(archiveSaverProvider).save(archive);

        state = switch (saved) {
          // AF-03. The archive stays retrievable, so the state keeps the job
          // and the screen can offer the save again.
          Failure<String>(:final message) => PersonalExportSaveRefused(
            message,
            export,
          ),
          Success<String>(:final value) => PersonalExportSaved(
            value,
            archive.sizeBytes,
          ),
        };
    }
  }
}
