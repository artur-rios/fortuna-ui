/// The time, as the application reads it (Testing Specification §6.2: "An
/// injected clock, never `DateTime.now()` in production code").
///
/// Everything that needs the time asks [clockProvider], through `ref.now()`
/// where there is a `ref`, or takes a [Clock] where there is not. A test then
/// pins the time by overriding the provider or passing its own clock, instead
/// of racing the real one — the goal editor's save test once failed when a run
/// crossed midnight. `tool/check_boundaries.dart` keeps it that way.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the time now.
typedef Clock = DateTime Function();

/// The system clock: the one place the application reads it.
DateTime systemClock() => DateTime.now();

/// The application's clock. Overridden in tests.
final clockProvider = Provider<Clock>((ref) => systemClock);

/// The time now, by the application's clock, from a widget.
extension WidgetRefClock on WidgetRef {
  DateTime now() => read(clockProvider)();
}

/// The time now, by the application's clock, from a provider or notifier.
extension RefClock on Ref {
  DateTime now() => read(clockProvider)();
}
