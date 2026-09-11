/// The drill path (UC-37).
///
/// `FR-CH-07` is the reason this is a stack rather than a single "current
/// level": a user looking at a figure must be able to see what bounds it.
/// "R$ 320 of groceries" and "R$ 320 of groceries at one shop in March" are
/// different claims, and a screen that shows the number without the path has
/// no way to tell them apart.
///
/// `FR-CH-06` then falls out of the same shape: stepping back is popping the
/// stack, available at every level because every level is on it.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../data/aggregation_repository.dart';

/// One step taken into the data.
@immutable
class DrillStep {
  const DrillStep({
    required this.label,
    required this.key,
    required this.dimension,
  });

  /// What the user selected, in the words the chart showed them.
  final String label;

  /// What the API descends with. Taken from the bucket, never from a
  /// coordinate (`FR-CH-08`).
  final String key;

  /// What the level beneath this step groups by.
  final String dimension;

  @override
  bool operator ==(Object other) =>
      other is DrillStep &&
      other.label == label &&
      other.key == key &&
      other.dimension == dimension;

  @override
  int get hashCode => Object.hash(label, key, dimension);
}

/// Where the drill-down is, and what it is showing.
@immutable
sealed class DrillState {
  const DrillState();
}

/// `AF-04`: nothing is drilled, so the chart stands unfiltered.
@immutable
final class AtChart extends DrillState {
  const AtChart();
}

@immutable
final class DrillLoading extends DrillState {
  const DrillLoading(this.path);

  final List<DrillStep> path;
}

@immutable
final class DrillLoaded extends DrillState {
  const DrillLoaded(this.path, this.level);

  final List<DrillStep> path;
  final DrillLevel level;
}

/// `AF-02`: the request failed. The path is kept so the level above is still
/// reachable, and so a retry knows what to ask for again.
@immutable
final class DrillFailed extends DrillState {
  const DrillFailed(this.path, this.reason);

  final List<DrillStep> path;
  final String reason;
}

/// Descending, stepping back, and remembering where the user is.
///
/// A `Notifier` rather than screen state, which is what satisfies `AF-05`:
/// the provider outlives the widget, so leaving the screen and returning
/// finds the path as it was. A full application reload starts at the chart
/// again, which the specification does not ask to survive — that is UC-25's
/// requirement, not this one.
class DrillDownController extends Notifier<DrillState> {
  @override
  DrillState build() => const AtChart();

  /// The path as it stands, for the breadcrumb (`FR-CH-07`).
  List<DrillStep> get path => switch (state) {
    AtChart() => const [],
    DrillLoading(:final path) => path,
    DrillLoaded(:final path) => path,
    DrillFailed(:final path) => path,
  };

  /// Steps 1 to 4: descend from [bucket].
  ///
  /// `AF-06` needs no special case — a remainder group is a bucket with a
  /// drill-down key like any other, so it expands the same way.
  Future<void> descend(
    AggregationBucket bucket, {
    required String dimension,
    String? displayCurrencyCode,
  }) async {
    // FR-CH-08: what identifies the level is the bucket's own key, never
    // anything read from where the tap landed.
    final key = bucket.drillDownKey;
    if (key == null || key.isEmpty) return;

    final next = [
      ...path,
      DrillStep(label: bucket.label, key: key, dimension: dimension),
    ];

    await _load(next, displayCurrencyCode: displayCurrencyCode);
  }

  /// Step 7 and `FR-CH-06`: back to the level above.
  ///
  /// `AF-04`: stepping back from the first level returns to the unfiltered
  /// chart rather than to an empty drill.
  Future<void> stepBack({String? displayCurrencyCode}) async {
    final current = path;
    if (current.isEmpty) return;

    final next = current.sublist(0, current.length - 1);

    if (next.isEmpty) {
      state = const AtChart();
      return;
    }

    await _load(next, displayCurrencyCode: displayCurrencyCode);
  }

  /// Jumps to a point on the path, which is what a breadcrumb is for.
  Future<void> stepTo(int index, {String? displayCurrencyCode}) async {
    final current = path;
    if (index < 0) {
      state = const AtChart();
      return;
    }
    if (index >= current.length - 1) return;

    await _load(
      current.sublist(0, index + 1),
      displayCurrencyCode: displayCurrencyCode,
    );
  }

  /// `AF-02`: asks again for the level that failed.
  Future<void> retry({String? displayCurrencyCode}) async {
    final current = path;
    if (current.isEmpty) return;

    await _load(current, displayCurrencyCode: displayCurrencyCode);
  }

  /// Returns to the unfiltered chart.
  void reset() => state = const AtChart();

  Future<void> _load(
    List<DrillStep> next, {
    String? displayCurrencyCode,
  }) async {
    state = DrillLoading(next);

    final target = next.last;
    final result = await ref
        .read(aggregationRepositoryProvider)
        .drillDown(
          key: target.key,
          dimension: target.dimension,
          displayCurrencyCode: displayCurrencyCode,
        );

    state = switch (result) {
      Success<DrillLevel>(:final value) => DrillLoaded(next, value),
      // AF-02: the path survives the failure, so the level above is still
      // reachable and the retry knows what to ask for.
      Failure<DrillLevel>(:final message) => DrillFailed(next, message),
    };
  }
}

final drillDownControllerProvider =
    NotifierProvider<DrillDownController, DrillState>(DrillDownController.new);
