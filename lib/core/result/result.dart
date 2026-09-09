/// The result type every repository returns (IR-04).
///
/// A repository never throws. A failure is a value the interface renders, which
/// is what lets `FR-DA-14` hold — the API's own reason reaches the screen
/// instead of being flattened into an exception somebody catches and rewords.
library;

import 'package:meta/meta.dart';

/// Why an operation failed, at the granularity a screen actually branches on.
///
/// Deliberately coarse. The *reason* shown to the user is always
/// [Failure.message], which comes from the API (`FR-DA-14`); this enum only
/// says what shape of recovery the interface should offer.
enum FailureKind {
  /// The request was rejected as invalid, by the client or by the API.
  invalidInput,

  /// No session, or the session was rejected. The caller ends the session
  /// (`FR-SE-19`) rather than retrying.
  unauthenticated,

  /// Authenticated, but not permitted.
  forbidden,

  /// The target does not exist — including when it belongs to another user,
  /// which the API deliberately makes indistinguishable.
  notFound,

  /// A conflicting state: a duplicate, or a rule the client did not enforce.
  conflict,

  /// The API could not be reached, or did not answer in time. Retryable.
  unreachable,

  /// The API answered with a failure of its own.
  serverError,
}

/// The outcome of an operation: [Success] or [Failure], and nothing else.
@immutable
sealed class Result<T> {
  const Result();

  /// Whether this is a [Success]. Prefer an exhaustive `switch` where the value
  /// or the reason is actually needed.
  bool get isSuccess => this is Success<T>;

  /// The value, or `null` when this is a [Failure].
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };

  /// Maps a success's value, carrying a failure through untouched.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Success<R>(transform(value)),
    Failure<T>(:final message, :final kind) => Failure<R>(
      message: message,
      kind: kind,
    ),
  };
}

/// An operation that succeeded, carrying its value.
@immutable
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// An operation that failed, carrying the reason to show and the shape of it.
///
/// [message] is what the user sees. It comes from the API wherever the API
/// answered, and is never rewritten into something friendlier — a user who
/// cannot see why something was refused cannot fix it.
@immutable
final class Failure<T> extends Result<T> {
  const Failure({required this.message, required this.kind});

  final String message;
  final FailureKind kind;

  @override
  bool operator ==(Object other) =>
      other is Failure<T> && other.message == message && other.kind == kind;

  @override
  int get hashCode => Object.hash(message, kind);

  @override
  String toString() => 'Failure($kind: $message)';
}
