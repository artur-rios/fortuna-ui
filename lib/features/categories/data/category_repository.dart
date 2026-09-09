/// The category tree (UC-26).
///
/// The API returns the tree already nested, so the client does not assemble it
/// from a flat list — which also means the shape on screen is the shape the API
/// vouches for, rather than one this client inferred from parent ids.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// A category and the categories beneath it.
@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.children,
    this.parentId,
    this.isDeleted = false,
  });

  final String id;
  final String name;
  final List<Category> children;
  final String? parentId;
  final bool isDeleted;

  /// This category and every category beneath it.
  ///
  /// What `AF-02` needs: a parent may not be chosen from a category's own
  /// descendants, or the tree would contain a cycle.
  Iterable<Category> get selfAndDescendants sync* {
    yield this;
    for (final child in children) {
      yield* child.selfAndDescendants;
    }
  }
}

/// The whole tree.
@immutable
class CategoryTree {
  const CategoryTree({required this.roots, this.canSeedDefaults = false});

  final List<Category> roots;

  /// Whether the instance offers to seed a starting set. Surfaced in the empty
  /// state (`AF-06`) rather than leaving a new user with nothing to do.
  final bool canSeedDefaults;

  bool get isEmpty => roots.isEmpty;

  /// Every category, at any depth.
  Iterable<Category> get all => roots.expand((root) => root.selfAndDescendants);

  /// Finds a category anywhere in the tree.
  Category? find(String id) {
    for (final category in all) {
      if (category.id == id) return category;
    }
    return null;
  }

  /// The categories that may be [category]'s parent without creating a cycle
  /// (`AF-02`).
  ///
  /// A category may not be its own parent, nor a descendant's child. Computed
  /// here rather than filtered in the widget so the rule is testable without a
  /// screen.
  List<Category> validParentsFor(Category? category) {
    if (category == null) return all.toList();

    final forbidden = category.selfAndDescendants.map((c) => c.id).toSet();
    return [
      for (final candidate in all)
        if (!forbidden.contains(candidate.id)) candidate,
    ];
  }
}

abstract interface class CategoryRepository {
  Future<Result<CategoryTree>> readTree();
  Future<Result<void>> create({required String name, String? parentId});
  Future<Result<void>> update({
    required String id,
    required String name,
    String? parentId,
  });
  Future<Result<void>> delete(String id);

  /// Moves a category's transactions to another before it is removed
  /// (`AF-03`).
  Future<Result<void>> reassign({
    required String fromId,
    required String toId,
    bool includeDescendants,
  });
}

class HttpCategoryRepository implements CategoryRepository {
  HttpCategoryRepository(this._client);

  factory HttpCategoryRepository.fromDio(Dio dio) =>
      HttpCategoryRepository(CategoriesClient(dio));

  final CategoriesClient _client;

  @override
  Future<Result<CategoryTree>> readTree() async {
    try {
      final response = await _client.getApiCategories();
      final tree = response.data;

      return Success(
        CategoryTree(
          roots: [
            for (final category in tree?.categories ?? const <CategoryOutput>[])
              _from(category),
          ],
          canSeedDefaults: tree?.canSeedDefaults ?? false,
        ),
      );
    } on DioException catch (exception) {
      return failureFromDioException<CategoryTree>(exception);
    }
  }

  @override
  Future<Result<void>> create({required String name, String? parentId}) => _run(
    () => _client.postApiCategories(
      body: CreateCategoryCommand(name: name, parentId: parentId),
    ),
  );

  @override
  Future<Result<void>> update({
    required String id,
    required String name,
    String? parentId,
  }) => _run(
    () => _client.putApiCategoriesId(
      id: id,
      body: UpdateCategoryCommand(name: name, parentId: parentId),
    ),
  );

  @override
  Future<Result<void>> delete(String id) =>
      _run(() => _client.deleteApiCategoriesId(id: id));

  @override
  Future<Result<void>> reassign({
    required String fromId,
    required String toId,
    bool includeDescendants = true,
  }) => _run(
    () => _client.postApiCategoriesIdReassign(
      id: fromId,
      body: ReassignCategoryTransactionsCommand(
        targetCategoryId: toId,
        includeDescendants: includeDescendants,
      ),
    ),
  );

  /// Runs a command, turning any refusal into a failure carrying the API's own
  /// reason (`FR-DA-14`).
  Future<Result<void>> _run(Future<Object?> Function() call) async {
    try {
      await call();
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }

  Category _from(CategoryOutput output) => Category(
    // The contract marks these nullable because the generator cannot express
    // "always present on a response"; a category with no id is not something
    // the tree can show, so it is named plainly rather than silently dropped.
    id: output.id ?? '',
    name: output.name ?? '',
    parentId: output.parentId,
    isDeleted: output.isDeleted ?? false,
    children: [
      for (final child in output.children ?? const <CategoryOutput>[])
        _from(child),
    ],
  );
}

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => HttpCategoryRepository.fromDio(ref.watch(dioProvider)),
);
