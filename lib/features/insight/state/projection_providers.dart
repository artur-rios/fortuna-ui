/// Projection state (UC-38).
///
/// Nothing here is kept. `FR-PJ-05` forbids persisting a projection, and
/// these providers hold one only for as long as the screen is showing it —
/// a forecast kept past its read would age into a claim about the past that
/// nobody made.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../../core/result/result.dart';
import '../../preferences/state/preferences_controller.dart';
import '../data/projection_repository.dart';

/// How far forward to look.
enum Horizon {
  oneMonth(30, 'Next month'),
  threeMonths(90, 'Next 3 months'),
  sixMonths(180, 'Next 6 months'),
  oneYear(365, 'Next year');

  const Horizon(this.days, this.label);

  final int days;
  final String label;
}

/// What a projection is being asked for.
@immutable
class ProjectionRequest {
  const ProjectionRequest({
    this.horizon = Horizon.threeMonths,
    this.displayCurrencyCode,
  });

  final Horizon horizon;
  final String? displayCurrencyCode;

  @override
  bool operator ==(Object other) =>
      other is ProjectionRequest &&
      other.horizon == horizon &&
      other.displayCurrencyCode == displayCurrencyCode;

  @override
  int get hashCode => Object.hash(horizon, displayCurrencyCode);
}

/// Where the user stands now (`FR-PJ-01`, step 1).
final netPositionProvider = FutureProvider<NetPosition>(
  retry: (retryCount, error) => null,
  (ref) async {
    final currency = ref.watch(preferencesProvider).displayCurrency;

    final result = await ref
        .read(projectionRepositoryProvider)
        .netPosition(displayCurrencyCode: currency);

    return switch (result) {
      Success<NetPosition>(:final value) => value,
      // AF-02.
      Failure<NetPosition>(:final message) => throw ProjectionUnavailable(
        message,
      ),
    };
  },
);

/// The forward projection over the chosen period (`FR-PJ-02`, step 2).
final cashFlowProvider =
    FutureProvider.family<CashFlowProjection, ProjectionRequest>(
      retry: (retryCount, error) => null,
      (ref, request) async {
        final result = await ref
            .read(projectionRepositoryProvider)
            .cashFlow(
              horizonDays: request.horizon.days,
              displayCurrencyCode: request.displayCurrencyCode,
            );

        return switch (result) {
          Success<CashFlowProjection>(:final value) => value,
          Failure<CashFlowProjection>(:final message) =>
            throw ProjectionUnavailable(message),
        };
      },
    );

/// What is already committed to (`FR-PJ-03`, step 3).
final obligationsProvider =
    FutureProvider.family<CommittedObligations, ProjectionRequest>(
      retry: (retryCount, error) => null,
      (ref, request) async {
        final result = await ref
            .read(projectionRepositoryProvider)
            .obligations(
              horizonDays: request.horizon.days,
              displayCurrencyCode: request.displayCurrencyCode,
            );

        return switch (result) {
          Success<CommittedObligations>(:final value) => value,
          Failure<CommittedObligations>(:final message) =>
            throw ProjectionUnavailable(message),
        };
      },
    );

class ProjectionUnavailable implements Exception {
  const ProjectionUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}
