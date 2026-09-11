/// Deleted record state (UC-40).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/deleted_record_repository.dart';

/// Everything deleted, across the kinds this client can act on.
final deletedRecordsProvider = FutureProvider<List<DeletedRecord>>(
  retry: (retryCount, error) => null,
  (ref) async {
    ref.read(sessionTeardownProvider).register('deletedRecords', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(deletedRecordRepositoryProvider).list();

    return switch (result) {
      Success<List<DeletedRecord>>(:final value) => value,
      Failure<List<DeletedRecord>>(:final message) =>
        throw DeletedRecordsUnavailable(message),
    };
  },
);

class DeletedRecordsUnavailable implements Exception {
  const DeletedRecordsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Restoring and permanently removing.
class DeletedRecordActions {
  const DeletedRecordActions(this._ref);

  final Ref _ref;

  /// Step 2: back into the views it belongs to.
  Future<Result<void>> restore(DeletedRecord record) => _afterChange(
    () => _ref.read(deletedRecordRepositoryProvider).restore(record),
  );

  /// Steps 3 to 5: gone, and not recoverable.
  Future<Result<void>> purge(DeletedRecord record) => _afterChange(
    () => _ref.read(deletedRecordRepositoryProvider).purge(record),
  );

  Future<Result<void>> _afterChange(
    Future<Result<void>> Function() call,
  ) async {
    final result = await call();

    // Either act changes what the deleted list holds, and a restore also
    // changes what every live view holds. The list is re-read rather than
    // edited in place: which views a restored record returns to is the
    // instance's answer, not this client's.
    if (result.isSuccess) _ref.invalidate(deletedRecordsProvider);

    return result;
  }
}

final deletedRecordActionsProvider = Provider<DeletedRecordActions>(
  DeletedRecordActions.new,
);
