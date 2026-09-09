/// Moving a category's transactions elsewhere (UC-26 step 5, AF-03, AF-04).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/category_repository.dart';
import '../state/category_providers.dart';

Future<void> showReassignDialog(
  BuildContext context,
  WidgetRef ref, {
  required Category from,
}) => showDialog<void>(
  context: context,
  builder: (context) => _ReassignDialog(from: from),
);

class _ReassignDialog extends ConsumerStatefulWidget {
  const _ReassignDialog({required this.from});

  final Category from;

  @override
  ConsumerState<_ReassignDialog> createState() => _ReassignDialogState();
}

class _ReassignDialogState extends ConsumerState<_ReassignDialog> {
  String? _targetId;
  String? _refusal;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(categoryTreeProvider).value;

    // AF-04: reassigning to the same category is refused, so it is not offered.
    final candidates = [
      for (final candidate in tree?.all ?? const <Category>[])
        if (candidate.id != widget.from.id) candidate,
    ];

    return AlertDialog(
      title: Text('Move transactions out of ${widget.from.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Every transaction in this category, and in the categories beneath '
            'it, moves to the one you choose.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            initialValue: _targetId,
            decoration: const InputDecoration(labelText: 'Move them to'),
            items: [
              for (final candidate in candidates)
                DropdownMenuItem<String?>(
                  value: candidate.id,
                  child: Text(candidate.name),
                ),
            ],
            onChanged: (value) => setState(() => _targetId = value),
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
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submitting || _targetId == null ? null : _submit,
          child: const Text('Move'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _refusal = null;
    });

    final failure = await ref
        .read(categoryActionsProvider)
        .reassign(fromId: widget.from.id, toId: _targetId!);

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
