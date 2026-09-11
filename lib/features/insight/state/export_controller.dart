/// Producing and saving an export (UC-39).
///
/// The states are separate types rather than flags because each is a
/// different thing to say. `AF-03` in particular is not a failure of the
/// export — the file exists, and the only thing that went wrong is where the
/// user pointed it — so it keeps the file and offers the save again. A
/// boolean `didSave` would have lost exactly that distinction.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/export_repository.dart';
import '../data/export_saver.dart';

/// How often a queued export is asked about (`FR-EX-04`).
const exportPollInterval = Duration(seconds: 2);

@immutable
sealed class ExportProgress {
  const ExportProgress();
}

@immutable
final class ExportIdle extends ExportProgress {
  const ExportIdle();
}

/// `FR-EX-04`: the interface is not blocked while this runs.
@immutable
final class ExportRunning extends ExportProgress {
  const ExportRunning({this.export});

  /// The job, once the instance has named one. Null while the request is in
  /// flight and it is not yet known whether this will be queued at all.
  final DataExport? export;
}

/// Produced and in hand, waiting to be put somewhere.
@immutable
final class ExportReady extends ExportProgress {
  const ExportReady(this.file, {this.saveRefusal});

  final ExportedFile file;

  /// `AF-03`: the platform declined the last save. The file is still here.
  final String? saveRefusal;
}

@immutable
final class ExportSaved extends ExportProgress {
  const ExportSaved(this.path);

  final String path;
}

/// `AF-02`.
@immutable
final class ExportFailed extends ExportProgress {
  const ExportFailed(this.reason);

  final String reason;
}

/// `AF-04`: produced, but gone before it was retrieved.
@immutable
final class ExportExpired extends ExportProgress {
  const ExportExpired();
}

class ExportController extends Notifier<ExportProgress> {
  Timer? _poller;

  @override
  ExportProgress build() {
    ref.onDispose(() => _poller?.cancel());
    return const ExportIdle();
  }

  /// Steps 3 and 4.
  Future<void> produce({
    required String recordSet,
    required ExportFormat format,
    required List<ExportFilter> filters,
    String? displayCurrencyCode,
    String? locale,
  }) async {
    state = const ExportRunning();

    final result = await ref
        .read(exportRepositoryProvider)
        .request(
          recordSet: recordSet,
          format: format,
          filters: filters,
          displayCurrencyCode: displayCurrencyCode,
          locale: locale,
        );

    switch (result) {
      case Success<ExportOutcome>(value: final ExportDelivered delivered):
        state = ExportReady(delivered.file);

      case Success<ExportOutcome>(value: final ExportQueued queued):
        // AF-05: the job is kept, so leaving the screen does not lose it.
        state = ExportRunning(export: queued.export);
        _startPolling(queued.export);

      // AF-02 and AF-06 both land here in the API's own words.
      case Failure<ExportOutcome>(:final message):
        state = ExportFailed(message);
    }
  }

  /// Step 5: put the produced file somewhere.
  Future<void> save() async {
    final current = state;
    if (current is! ExportReady) return;

    final result = await ref.read(exportSaverProvider).save(current.file);

    state = switch (result) {
      Success<String>(:final value) => ExportSaved(value),
      // AF-03: the file survives the refusal, and the save is offered again.
      Failure<String>(:final message) => ExportReady(
        current.file,
        saveRefusal: message,
      ),
    };
  }

  /// Retrieves a finished job's file.
  Future<void> retrieve(DataExport export) async {
    // AF-04: asked before the request, so an export the instance has already
    // discarded is reported as expired rather than as a failure to download.
    if (export.hasExpired(now: DateTime.now())) {
      state = const ExportExpired();
      return;
    }

    final result = await ref.read(exportRepositoryProvider).download(export);

    state = switch (result) {
      Success<ExportedFile>(:final value) => ExportReady(value),
      Failure<ExportedFile>(:final message) => ExportFailed(message),
    };
  }

  /// Returns to the start, so a new export can be asked for (`AF-04`).
  void reset() {
    _poller?.cancel();
    state = const ExportIdle();
  }

  void _startPolling(DataExport export) {
    _poller?.cancel();
    _poller = Timer.periodic(exportPollInterval, (timer) async {
      final result = await ref.read(exportRepositoryProvider).read(export.id);

      if (result case Success<DataExport>(:final value)) {
        if (!value.state.isFinished) {
          state = ExportRunning(export: value);
          return;
        }

        timer.cancel();

        if (value.state == ExportState.failed) {
          // AF-02: the API's own reason for the job it could not finish.
          state = ExportFailed(
            value.failureReason ?? 'The export could not be produced.',
          );
          return;
        }

        await retrieve(value);
      }
      // A poll that failed is not a job that failed. The next tick asks
      // again rather than declaring an export dead on one bad answer.
    });
  }
}

final exportControllerProvider =
    NotifierProvider<ExportController, ExportProgress>(ExportController.new);
