/// The pager under a list browsed a page at a time (UC-25 step 6).
library;

import 'package:material_ui/material_ui.dart';

import '../../core/network/paging.dart';

/// Where the reader is in a [PagedList], with a step either way.
///
/// Meant for `Scaffold.bottomNavigationBar`, which keeps a floating action
/// button clear of it, as in the transaction grid. Its keys are [keyPrefix]
/// followed by `.total`, `.previous`, `.pageNumber` and `.next`.
class PageBar extends StatelessWidget {
  const PageBar({
    required this.page,
    required this.keyPrefix,
    required this.onGoTo,
    this.singular = 'record',
    this.plural = 'records',
    super.key,
  });

  final PagedList<Object?> page;
  final String keyPrefix;

  /// Asks for a page by number.
  final void Function(int pageNumber) onGoTo;

  /// What one item is called, and many.
  final String singular;
  final String plural;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 3,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              '${page.totalItems} ${page.totalItems == 1 ? singular : plural}',
              key: Key('$keyPrefix.total'),
            ),
            const Spacer(),
            IconButton(
              key: Key('$keyPrefix.previous'),
              tooltip: 'Previous page',
              icon: const Icon(Icons.chevron_left),
              onPressed: page.hasPrevious
                  ? () => onGoTo(page.pageNumber - 1)
                  : null,
            ),
            Text(
              // The page the API answered with (AF-05).
              'Page ${page.pageNumber} of ${page.totalPages}',
              key: Key('$keyPrefix.pageNumber'),
            ),
            IconButton(
              key: Key('$keyPrefix.next'),
              tooltip: 'Next page',
              icon: const Icon(Icons.chevron_right),
              onPressed: page.hasNext
                  ? () => onGoTo(page.pageNumber + 1)
                  : null,
            ),
          ],
        ),
      ),
    ),
  );
}
