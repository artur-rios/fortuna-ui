/// Tags and counterparties (UC-27).
///
/// The two are structurally identical — an id and a name — and the
/// specification handles them in one use case, so they share one interface with
/// two implementations rather than two near-copies of the same code. The kind
/// travels with the repository so the interface stays free of it.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Which of the two a repository serves.
///
/// Carries its own words, because "no tags yet" and "no counterparties yet"
/// are the only places the difference is visible to a user.
enum LabelKind {
  tag(
    singular: 'tag',
    plural: 'Tags',
    explanation: 'Tags are free-form labels. A transaction can carry several.',
  ),
  counterparty(
    singular: 'counterparty',
    plural: 'Counterparties',
    explanation:
        'A counterparty is who was on the other side — a shop, an employer, '
        'a person.',
  );

  const LabelKind({
    required this.singular,
    required this.plural,
    required this.explanation,
  });

  final String singular;
  final String plural;
  final String explanation;
}

/// A tag or a counterparty.
@immutable
class Label {
  const Label({required this.id, required this.name, this.isDeleted = false});

  final String id;
  final String name;
  final bool isDeleted;
}

abstract interface class LabelRepository {
  LabelKind get kind;

  Future<Result<List<Label>>> list();
  Future<Result<void>> create(String name);
  Future<Result<void>> rename({required String id, required String name});
  Future<Result<void>> delete(String id);
}

/// Shared plumbing: every operation returns a result, and a refusal carries the
/// API's own reason (`FR-DA-14`).
mixin _CommandRunner {
  Future<Result<void>> run(Future<Object?> Function() call) async {
    try {
      await call();
      return const Success(null);
    } on DioException catch (exception) {
      return failureFromDioException<void>(exception);
    }
  }
}

class HttpTagRepository with _CommandRunner implements LabelRepository {
  HttpTagRepository(this._client);

  factory HttpTagRepository.fromDio(Dio dio) =>
      HttpTagRepository(TagsClient(dio));

  final TagsClient _client;

  @override
  LabelKind get kind => LabelKind.tag;

  @override
  Future<Result<List<Label>>> list() async {
    try {
      final response = await _client.getApiTags();
      return Success([
        for (final tag in response.data?.tags ?? const <TagOutput>[])
          Label(
            id: tag.id ?? '',
            name: tag.name ?? '',
            isDeleted: tag.isDeleted ?? false,
          ),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Label>>(exception);
    }
  }

  @override
  Future<Result<void>> create(String name) =>
      run(() => _client.postApiTags(body: CreateTagCommand(name: name)));

  @override
  Future<Result<void>> rename({required String id, required String name}) =>
      run(
        () => _client.putApiTagsId(
          id: id,
          body: UpdateTagCommand(name: name),
        ),
      );

  @override
  Future<Result<void>> delete(String id) =>
      run(() => _client.deleteApiTagsId(id: id));
}

class HttpCounterpartyRepository
    with _CommandRunner
    implements LabelRepository {
  HttpCounterpartyRepository(this._client);

  factory HttpCounterpartyRepository.fromDio(Dio dio) =>
      HttpCounterpartyRepository(CounterpartiesClient(dio));

  final CounterpartiesClient _client;

  @override
  LabelKind get kind => LabelKind.counterparty;

  @override
  Future<Result<List<Label>>> list() async {
    try {
      final response = await _client.getApiCounterparties();
      return Success([
        for (final counterparty
            in response.data?.counterparties ?? const <CounterpartyOutput>[])
          Label(
            id: counterparty.id ?? '',
            name: counterparty.name ?? '',
            isDeleted: counterparty.isDeleted ?? false,
          ),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<Label>>(exception);
    }
  }

  @override
  Future<Result<void>> create(String name) => run(
    () => _client.postApiCounterparties(
      body: CreateCounterpartyCommand(name: name),
    ),
  );

  @override
  Future<Result<void>> rename({required String id, required String name}) =>
      run(
        () => _client.putApiCounterpartiesId(
          id: id,
          body: UpdateCounterpartyCommand(name: name),
        ),
      );

  @override
  Future<Result<void>> delete(String id) =>
      run(() => _client.deleteApiCounterpartiesId(id: id));
}

/// One repository per kind, selected by the family's argument.
final labelRepositoryProvider = Provider.family<LabelRepository, LabelKind>((
  ref,
  kind,
) {
  final dio = ref.watch(dioProvider);

  return switch (kind) {
    LabelKind.tag => HttpTagRepository.fromDio(dio),
    LabelKind.counterparty => HttpCounterpartyRepository.fromDio(dio),
  };
});
