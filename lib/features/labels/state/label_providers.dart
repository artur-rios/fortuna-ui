/// Tag and counterparty state (UC-27).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/label_repository.dart';

/// The labels of one kind, sorted by name so the list does not reorder itself
/// on every read.
final labelsProvider = FutureProvider.family<List<Label>, LabelKind>(
  retry: (retryCount, error) => null,
  (ref, kind) async {
    ref.read(sessionTeardownProvider).register('labels:${kind.name}', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(labelRepositoryProvider(kind)).list();

    return switch (result) {
      Success<List<Label>>(:final value) =>
        value.toList()..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        ),
      Failure<List<Label>>(:final message) => throw LabelsUnavailable(message),
    };
  },
);

class LabelsUnavailable implements Exception {
  const LabelsUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Changes to one kind of label, re-reading the list after a confirmed change.
class LabelActions {
  const LabelActions(this._ref, this.kind);

  final Ref _ref;
  final LabelKind kind;

  LabelRepository get _repository => _ref.read(labelRepositoryProvider(kind));

  Future<Failure<void>?> create(String name) =>
      _afterChange(_repository.create(name));

  Future<Failure<void>?> rename({required String id, required String name}) =>
      _afterChange(_repository.rename(id: id, name: name));

  Future<Failure<void>?> delete(String id) =>
      _afterChange(_repository.delete(id));

  Future<Failure<void>?> _afterChange(Future<Result<void>> operation) async {
    final result = await operation;

    return switch (result) {
      Success<void>() => () {
        _ref.invalidate(labelsProvider(kind));
        return null;
      }(),
      final Failure<void> failure => failure,
    };
  }
}

final labelActionsProvider = Provider.family<LabelActions, LabelKind>(
  LabelActions.new,
);
