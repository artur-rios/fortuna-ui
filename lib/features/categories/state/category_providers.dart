/// The category tree's state (UC-26).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/session/session_teardown.dart';
import '../data/category_repository.dart';

/// The tree, re-read after every change that could have altered it.
///
/// Automatic retry is off: Riverpod retries a failed provider by default, which
/// would poll an unreachable instance behind the user's back while the screen
/// offers them a retry for the same thing.
final categoryTreeProvider = FutureProvider<CategoryTree>(
  retry: (retryCount, error) => null,
  (ref) async {
    // Reference data, cleared when the session ends (BR-32, BR-33).
    ref.read(sessionTeardownProvider).register('categories', () async {
      ref.invalidateSelf();
    });

    final result = await ref.read(categoryRepositoryProvider).readTree();

    return switch (result) {
      Success<CategoryTree>(:final value) => value,
      Failure<CategoryTree>(:final message) => throw CategoriesUnavailable(
        message,
      ),
    };
  },
);

/// Raised when the tree could not be read.
class CategoriesUnavailable implements Exception {
  const CategoriesUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Performs the changes, and re-reads the tree when one succeeds.
///
/// Returns the failure rather than swallowing it, so the screen can present the
/// API's own reason — which `AF-01`, `AF-02`, `AF-03` and `AF-05` all require.
class CategoryActions {
  const CategoryActions(this._ref);

  final Ref _ref;

  CategoryRepository get _repository => _ref.read(categoryRepositoryProvider);

  Future<Failure<void>?> create({required String name, String? parentId}) =>
      _afterChange(_repository.create(name: name, parentId: parentId));

  Future<Failure<void>?> update({
    required String id,
    required String name,
    String? parentId,
  }) =>
      _afterChange(_repository.update(id: id, name: name, parentId: parentId));

  Future<Failure<void>?> delete(String id) =>
      _afterChange(_repository.delete(id));

  Future<Failure<void>?> reassign({
    required String fromId,
    required String toId,
  }) => _afterChange(_repository.reassign(fromId: fromId, toId: toId));

  /// Invalidates the tree on success only.
  ///
  /// A refused change left the tree as it was, and re-reading after one would
  /// flicker the screen for nothing.
  Future<Failure<void>?> _afterChange(Future<Result<void>> operation) async {
    final result = await operation;

    return switch (result) {
      Success<void>() => () {
        _ref.invalidate(categoryTreeProvider);
        return null;
      }(),
      final Failure<void> failure => failure,
    };
  }
}

final categoryActionsProvider = Provider<CategoryActions>(CategoryActions.new);
