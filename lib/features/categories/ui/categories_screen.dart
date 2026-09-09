/// The category tree (UC-26).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/ui/sign_out_action.dart';
import '../data/category_repository.dart';
import '../state/category_providers.dart';
import 'category_editor.dart';
import 'reassign_dialog.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tree = ref.watch(categoryTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: const [SignOutAction()],
      ),
      floatingActionButton: tree.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => showCategoryEditor(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('New category'),
            )
          : null,
      body: tree.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Failed(
          message: error is CategoriesUnavailable
              ? error.message
              : 'The categories could not be loaded.',
          onRetry: () => ref.invalidate(categoryTreeProvider),
        ),
        data: (data) => data.isEmpty
            ? _Empty(onCreate: () => showCategoryEditor(context, ref))
            : _Tree(tree: data),
      ),
    );
  }
}

class _Tree extends ConsumerWidget {
  const _Tree({required this.tree});

  final CategoryTree tree;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.only(bottom: 88),
    children: [
      for (final root in tree.roots)
        _CategoryNode(category: root, tree: tree, depth: 0),
    ],
  );
}

class _CategoryNode extends ConsumerWidget {
  const _CategoryNode({
    required this.category,
    required this.tree,
    required this.depth,
  });

  final Category category;
  final CategoryTree tree;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + depth * 20, right: 8),
      leading: Icon(
        category.children.isEmpty ? Icons.label_outline : Icons.folder_outlined,
        size: 20,
      ),
      title: Text(category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit ${category.name}',
            onPressed: () =>
                showCategoryEditor(context, ref, editing: category),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete ${category.name}',
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile,
        for (final child in category.children)
          _CategoryNode(category: child, tree: tree, depth: depth + 1),
      ],
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${category.name}?'),
        content: Text(
          category.children.isEmpty
              ? 'It can be restored afterwards.'
              : 'It has ${category.children.length} categories beneath it. '
                    'It can be restored afterwards.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final failure = await ref.read(categoryActionsProvider).delete(category.id);
    if (failure == null || !context.mounted) return;

    // AF-03. The API refused — usually because transactions still reference
    // this category. Its reason is shown, and reassignment offered rather than
    // leaving the user to work out what to do about it.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        action: SnackBarAction(
          label: 'Reassign',
          onPressed: () => showReassignDialog(context, ref, from: category),
        ),
        duration: const Duration(seconds: 8),
      ),
    );
  }
}

/// `AF-06`.
class _Empty extends StatelessWidget {
  const _Empty({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.label_outline, size: 40),
        const SizedBox(height: 16),
        Text(
          'No categories yet',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        const Text('Categories are how spending is grouped and budgeted.'),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onCreate,
          child: const Text('Create the first one'),
        ),
      ],
    ),
  );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    ),
  );
}
