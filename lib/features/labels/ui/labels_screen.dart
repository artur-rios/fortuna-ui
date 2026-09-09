/// Tags and counterparties (UC-27).
///
/// One screen with two tabs, because the specification treats them as one use
/// case and they behave identically — the only difference a user sees is the
/// words.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/ui/sign_out_action.dart';
import '../data/label_repository.dart';
import '../state/label_providers.dart';

class LabelsScreen extends StatelessWidget {
  const LabelsScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: LabelKind.values.length,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Tags and counterparties'),
        actions: const [SignOutAction()],
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Tags'),
            Tab(text: 'Counterparties'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          _LabelList(kind: LabelKind.tag),
          _LabelList(kind: LabelKind.counterparty),
        ],
      ),
    ),
  );
}

class _LabelList extends ConsumerWidget {
  const _LabelList({required this.kind});

  final LabelKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(labelsProvider(kind));

    return Scaffold(
      floatingActionButton: labels.hasValue
          ? FloatingActionButton.extended(
              heroTag: 'new-${kind.name}',
              onPressed: () => showLabelEditor(context, ref, kind: kind),
              icon: const Icon(Icons.add),
              label: Text('New ${kind.singular}'),
            )
          : null,
      body: labels.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Failed(
          message: error is LabelsUnavailable
              ? error.message
              : 'The ${kind.plural.toLowerCase()} could not be loaded.',
          onRetry: () => ref.invalidate(labelsProvider(kind)),
        ),
        data: (data) => data.isEmpty
            ? _Empty(
                kind: kind,
                onCreate: () => showLabelEditor(context, ref, kind: kind),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    _LabelTile(kind: kind, label: data[index]),
              ),
      ),
    );
  }
}

class _LabelTile extends ConsumerWidget {
  const _LabelTile({required this.kind, required this.label});

  final LabelKind kind;
  final Label label;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    leading: Icon(
      kind == LabelKind.tag ? Icons.sell_outlined : Icons.store_outlined,
      size: 20,
    ),
    title: Text(label.name),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Rename ${label.name}',
          onPressed: () =>
              showLabelEditor(context, ref, kind: kind, editing: label),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete ${label.name}',
          onPressed: () => _delete(context, ref),
        ),
      ],
    ),
  );

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${label.name}?'),
        content: const Text('It can be restored afterwards.'),
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

    final failure = await ref.read(labelActionsProvider(kind)).delete(label.id);
    if (failure == null || !context.mounted) return;

    // AF-02 and AF-03: the API's reason, whatever it was — transactions still
    // referencing it, or a target that is not there.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}

/// `AF-04`.
class _Empty extends StatelessWidget {
  const _Empty({required this.kind, required this.onCreate});

  final LabelKind kind;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              kind == LabelKind.tag
                  ? Icons.sell_outlined
                  : Icons.store_outlined,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${kind.plural.toLowerCase()} yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(kind.explanation, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onCreate,
              child: Text('Create the first ${kind.singular}'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
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
  );
}

/// Creating or renaming (`AF-01`).
Future<void> showLabelEditor(
  BuildContext context,
  WidgetRef ref, {
  required LabelKind kind,
  Label? editing,
}) => showDialog<void>(
  context: context,
  builder: (context) => _LabelEditor(kind: kind, editing: editing),
);

class _LabelEditor extends ConsumerStatefulWidget {
  const _LabelEditor({required this.kind, this.editing});

  final LabelKind kind;
  final Label? editing;

  @override
  ConsumerState<_LabelEditor> createState() => _LabelEditorState();
}

class _LabelEditorState extends ConsumerState<_LabelEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.editing?.name ?? '',
  );

  String? _refusal;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.editing == null
          ? 'New ${widget.kind.singular}'
          : 'Rename ${widget.editing!.name}',
    ),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) => (value ?? '').trim().isEmpty
                ? 'A ${widget.kind.singular} needs a name.'
                : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          if (_refusal case final String refusal) ...[
            const SizedBox(height: 16),
            Text(
              refusal,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _submitting ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _submitting ? null : _submit,
        child: Text(widget.editing == null ? 'Create' : 'Save'),
      ),
    ],
  );

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
      _refusal = null;
    });

    final actions = ref.read(labelActionsProvider(widget.kind));
    final name = _name.text.trim();

    final failure = widget.editing == null
        ? await actions.create(name)
        : await actions.rename(id: widget.editing!.id, name: name);

    if (!mounted) return;

    if (failure == null) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _submitting = false;
      _refusal = failure.message;
    });
  }
}
