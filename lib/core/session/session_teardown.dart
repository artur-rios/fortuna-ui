/// What must be forgotten when a session ends (FR-SE-21, UC-12).
///
/// A registry rather than a hard-coded list, because the things that need
/// clearing belong to features this file must not know about — the cached
/// category tree, an open table's filters, a tracked import job. Each registers
/// itself; sign-out runs them all.
///
/// This is what makes "nothing about the previous user survives into the next
/// session" enforceable rather than a habit every future feature has to
/// remember. A shared desktop is the normal case, not the exception.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Callbacks to run when a session ends.
///
/// Keyed by name so a feature can replace its own registration without
/// accumulating duplicates across a hot reload or a rebuilt provider.
class SessionTeardown {
  final Map<String, Future<void> Function()> _callbacks = {};

  /// The names currently registered, for tests and diagnostics.
  Iterable<String> get registered => _callbacks.keys;

  /// Registers [onSessionEnd] under [name], replacing any previous entry.
  void register(String name, Future<void> Function() onSessionEnd) {
    _callbacks[name] = onSessionEnd;
  }

  /// Removes a registration, if present.
  void unregister(String name) => _callbacks.remove(name);

  /// Runs every registered callback.
  ///
  /// One that throws does not stop the others: a feature failing to clear its
  /// own cache must not leave the rest of the application holding the previous
  /// user's data. The failures are returned so the caller can decide what to
  /// say, rather than being swallowed here.
  Future<List<Object>> runAll() async {
    final failures = <Object>[];

    for (final entry in _callbacks.entries.toList()) {
      try {
        await entry.value();
      } on Object catch (error) {
        failures.add(error);
      }
    }

    return failures;
  }
}

final sessionTeardownProvider = Provider<SessionTeardown>(
  (ref) => SessionTeardown(),
);
