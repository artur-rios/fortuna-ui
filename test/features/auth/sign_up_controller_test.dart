import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/features/auth/data/registration_repository.dart';
import 'package:fortuna_ui/features/auth/state/sign_up_controller.dart';

/// Answers as the API would, and remembers what it was handed.
class FakeRegistration implements RegistrationRepository {
  FakeRegistration([Result<String> Function()? answer])
    : answer = answer ?? (() => const Success('Check your email.'));

  Result<String> Function() answer;
  final List<({String name, String email, String password})> submitted = [];

  @override
  Future<Result<String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    submitted.add((name: name, email: email, password: password));
    return answer();
  }
}

ProviderContainer containerWith(FakeRegistration repository) {
  final container = ProviderContainer(
    overrides: [registrationRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}

Future<SignUpState> submit(
  ProviderContainer container, {
  String name = 'New Person',
  String email = 'new@example.com',
  String password = 'a-long-secret',
}) async {
  await container
      .read(signUpControllerProvider.notifier)
      .submit(name: name, email: email, password: password);
  return container.read(signUpControllerProvider);
}

void main() {
  group('SignUpController', () {
    test('Given valid input '
        'When it is submitted '
        'Then the API message is what the user is shown', () async {
      final repository = FakeRegistration(
        () => const Success('Check your email.'),
      );

      final state = await submit(containerWith(repository));

      expect(state, isA<SignUpAccepted>());
      expect(state.message, 'Check your email.');
      expect(repository.submitted.single.name, 'New Person');
    });

    test('Given surrounding spaces '
        'When it is submitted '
        'Then name and address are trimmed and the password is not', () async {
      final repository = FakeRegistration();

      await submit(
        containerWith(repository),
        name: '  New Person ',
        email: ' new@example.com ',
        password: ' a long secret ',
      );

      final sent = repository.submitted.single;
      expect(sent.name, 'New Person');
      expect(sent.email, 'new@example.com');
      expect(sent.password, ' a long secret ');
    });

    test('Given a name of only spaces '
        'When it is submitted '
        'Then the name field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), name: '   ');

      expect(state, isA<SignUpInvalid>());
      expect((state as SignUpInvalid).field, SignUpField.name);
      expect(repository.submitted, isEmpty);
    });

    test('Given a name of 201 characters '
        'When it is submitted '
        'Then the name field is refused', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), name: 'a' * 201);

      expect((state as SignUpInvalid).field, SignUpField.name);
      expect(repository.submitted, isEmpty);
    });

    test('Given a name of exactly 200 characters '
        'When it is submitted '
        'Then it is sent', () async {
      final repository = FakeRegistration();

      await submit(containerWith(repository), name: 'a' * 200);

      expect(repository.submitted, hasLength(1));
    });

    test('Given a malformed address '
        'When it is submitted '
        'Then the email field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(containerWith(repository), email: 'nonsense');

      expect((state as SignUpInvalid).field, SignUpField.email);
      expect(repository.submitted, isEmpty);
    });

    test('Given an address of 257 characters '
        'When it is submitted '
        'Then the email field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(
        containerWith(repository),
        email: '${'a' * 245}@example.com', // 245 + 12 = 257
      );

      expect((state as SignUpInvalid).field, SignUpField.email);
      expect(repository.submitted, isEmpty);
    });

    test('Given a seven-character password '
        'When it is submitted '
        'Then the password field is refused and nothing is sent', () async {
      final repository = FakeRegistration();

      final state = await submit(
        containerWith(repository),
        password: '1234567',
      );

      expect((state as SignUpInvalid).field, SignUpField.password);
      expect(repository.submitted, isEmpty);
    });

    test('Given a closed instance '
        'When it answers '
        'Then its reason is shown without a retry state', () async {
      final repository = FakeRegistration(
        () => const Failure(
          message: 'This instance is not accepting new accounts.',
          kind: FailureKind.forbidden,
        ),
      );

      final state = await submit(containerWith(repository));

      expect(state, isA<SignUpRefused>());
      expect(state.message, 'This instance is not accepting new accounts.');
    });

    for (final kind in [FailureKind.unreachable, FailureKind.serverError]) {
      test('Given a $kind failure '
          'When it answers '
          'Then a retryable state carries the reason', () async {
        final repository = FakeRegistration(
          () => Failure(message: 'Try later.', kind: kind),
        );

        final state = await submit(containerWith(repository));

        expect(state, isA<SignUpUnreachable>());
        expect(state.message, 'Try later.');
      });
    }

    test('Given a refusal on screen '
        'When the user edits a field '
        'Then the message clears', () async {
      final container = containerWith(FakeRegistration());
      await submit(container, email: 'nonsense');

      container.read(signUpControllerProvider.notifier).reset();

      expect(container.read(signUpControllerProvider), isA<SignUpReady>());
    });
  });
}
