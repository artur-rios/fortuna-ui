/// Reading a whole list that the API serves in pages.
///
/// Every list endpoint pages its answer: `PageSize` defaults to 100 and the
/// instance caps it at `FORTUNA_PAGE_SIZE_MAX`, 100 unless configured lower.
/// A screen that presents a whole list — the tags, the accounts, the deleted
/// records — therefore reads every page, or it silently shows only the first.
///
/// A list that grows without bound — the audit trail, the import jobs — is
/// shown a page at a time instead, as [PagedList], the way the transaction
/// grid is (UC-25).
library;

import 'package:meta/meta.dart';

/// One page of a list, as the API answered it.
///
/// [totalPages] is the API's own count. Null where the answer did not say,
/// which is taken to mean that this page is the whole list.
typedef ListPage<T> = ({List<T> items, int? totalPages});

/// The page size a whole-list read asks for: the most a stock instance serves.
///
/// An instance configured to serve fewer pages them smaller and counts its
/// pages accordingly, and [readEveryPage] follows the count it answers with.
const wholeListPageSize = 100;

/// The most pages one read takes, so an answer that always claims another
/// page cannot keep the client asking for ever.
const maximumPagesRead = 1000;

/// Reads every page of a list, in order, and returns the items as served.
///
/// [readPage] asks for one page. A failure it throws is not caught here: a
/// list missing pages would be presented as complete, which is worse than a
/// failure the caller already knows how to show.
Future<List<T>> readEveryPage<T>(
  Future<ListPage<T>> Function(int pageNumber, int pageSize) readPage,
) async {
  final items = <T>[];

  for (var pageNumber = 1; pageNumber <= maximumPagesRead; pageNumber++) {
    final page = await readPage(pageNumber, wholeListPageSize);
    items.addAll(page.items);

    if (page.items.isEmpty || pageNumber >= (page.totalPages ?? 1)) break;
  }

  return items;
}

/// How many records a browsed page holds, as in the transaction grid.
const browsePageSize = 25;

/// One page of a list that is browsed a page at a time (UC-25).
@immutable
class PagedList<T> {
  const PagedList({
    required this.items,
    required this.pageNumber,
    required this.totalItems,
    required this.totalPages,
  });

  final List<T> items;

  /// The page the API answered with, which is not always the page asked for:
  /// asked for a page past the last, the API answers with the last
  /// (`UC-25 AF-05`).
  final int pageNumber;

  final int totalItems;
  final int totalPages;

  bool get isEmpty => items.isEmpty;
  bool get hasPrevious => pageNumber > 1;
  bool get hasNext => pageNumber < totalPages;
}
