/// Creating and editing a category (UC-26 steps 2–5, AF-01, AF-02).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_repository.dart';
import '../state/category_providers.dart';

/// Opens the editor. [editing] is null when creating.
Future<void> showCategoryEditor(
  BuildContext context,
  WidgetRef ref, {
  Category? editing,
}) => showDialog<void>(
  context: context,
  builder: (context) => _CategoryEditor(editing: editing),
);

class _CategoryEditor extends ConsumerStatefulWidget {
  const _CategoryEditor({this.editing});

  final Category? editing;

  @override
  ConsumerState<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends ConsumerState<_CategoryEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(
    text: widget.editing?.name ?? '',
  );

  String? _parentId;
  String? _refusal;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _parentId = widget.editing?.parentId;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(categoryTreeProvider).value;

    // AF-02: a category may not be parented to itself or to one of its own
    // descendants. The offending options are not offered at all — and if one
    // were submitted anyway, the API's refusal would still be shown below.
    final candidates = tree?.validParentsFor(widget.editing) ?? const [];

    return AlertDialog(
      title: Text(
        widget.editing == null
            ? 'New category'
            : 'Edit ${widget.editing!.name}',
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
              // AF-01, the half the client can enforce. A name that duplicates
              // a sibling is the API's to refuse, and its reason is shown.
              validator: (value) => (value ?? '').trim().isEmpty
                  ? 'A category needs a name.'
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              initialValue: _parentId,
              decoration: const InputDecoration(labelText: 'Parent'),
              items: [
                const DropdownMenuItem<String?>(
                  child: Text('None — a top-level category'),
                ),
                for (final candidate in candidates)
                  DropdownMenuItem<String?>(
                    value: candidate.id,
                    child: Text(candidate.name),
                  ),
              ],
              onChanged: (value) => setState(() => _parentId = value),
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
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _submitting = true;
      _refusal = null;
    });

    final actions = ref.read(categoryActionsProvider);
    final name = _name.text.trim();

    final failure = widget.editing == null
        ? await actions.create(name: name, parentId: _parentId)
        : await actions.update(
            id: widget.editing!.id,
            name: name,
            parentId: _parentId,
          );

    if (!mounted) return;

    // Nothing is reported as saved until the API has confirmed it (BR-04).
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
