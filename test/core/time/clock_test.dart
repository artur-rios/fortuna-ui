import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/time/clock.dart';

void main() {
  group('clockProvider', () {
    test('Given no override '
        'When the time is read '
        'Then it is the system time', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final before = DateTime.now();
      final now = container.read(clockProvider)();
      final after = DateTime.now();

      expect(now.isBefore(before), isFalse);
      expect(now.isAfter(after), isFalse);
    });

    test('Given a pinned clock '
        'When a provider reads the time '
        'Then it is the pinned time', () {
      final pinned = DateTime(2026, 11, 16, 23, 59, 59);
      final readNow = Provider<DateTime>((ref) => ref.now());
      final container = ProviderContainer(
        overrides: [clockProvider.overrideWithValue(() => pinned)],
      );
      addTearDown(container.dispose);

      expect(container.read(readNow), pinned);
    });

    testWidgets('Given a pinned clock '
        'When a widget reads the time '
        'Then it is the pinned time', (tester) async {
      final pinned = DateTime(2026, 11, 16, 23, 59, 59);
      DateTime? read;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [clockProvider.overrideWithValue(() => pinned)],
          child: Consumer(
            builder: (context, ref, _) {
              read = ref.now();
              return const SizedBox();
            },
          ),
        ),
      );

      expect(read, pinned);
    });
  });
}
