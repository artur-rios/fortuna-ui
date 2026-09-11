/// The data sources an instance supports (UC-30, step 1).
///
/// `FR-IN-01` asks for two things, and the second is the one that matters:
/// list the sources, **and say which are unavailable in the current mode**. An
/// offline desktop instance reaches no aggregator, and a source silently
/// missing from the list would leave the user wondering whether their bank is
/// unsupported. A source shown with a reason tells them the truth.
library;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fortuna_api_client/export.dart';
import 'package:meta/meta.dart';

import '../../../core/network/api_client.dart';
import '../../../core/result/result.dart';

/// Whether a source is reached over the network or fed from a file.
enum SourceKind {
  network(1),
  file(2);

  const SourceKind(this.wire);

  final int wire;

  static SourceKind from(DataSourceKind? kind) =>
      kind?.json == 2 ? SourceKind.file : SourceKind.network;
}

/// One data source the instance knows about.
@immutable
class DataSource {
  const DataSource({
    required this.name,
    required this.displayName,
    required this.kind,
    required this.isAvailable,
    required this.isNetworkBacked,
    this.unavailableReason,
    this.requiredInputs = const [],
  });

  /// What the API calls it, and what a connection is created against.
  final String name;

  final String displayName;
  final SourceKind kind;

  /// Whether it can be used in the mode this instance runs in (`AF-06`).
  final bool isAvailable;

  /// Whether using it discloses anything to an external processor, which is
  /// what makes consent a precondition (`FR-IN-02`, `BR-40`).
  final bool isNetworkBacked;

  /// The API's own words for why it cannot be used. Shown as given: the
  /// instance knows why and this client does not.
  final String? unavailableReason;

  /// What the user must supply to connect, as the API names each field.
  final List<String> requiredInputs;

  /// Whether connecting to this source needs consent first.
  ///
  /// A file source discloses nothing to anyone — the data never leaves the
  /// instance — so gating it behind an external-processing consent would be
  /// asking permission for something that is not happening.
  bool get needsExternalConsent => isNetworkBacked;
}

abstract interface class DataSourceRepository {
  Future<Result<List<DataSource>>> list();
}

class HttpDataSourceRepository implements DataSourceRepository {
  HttpDataSourceRepository(this._client);

  factory HttpDataSourceRepository.fromDio(Dio dio) =>
      HttpDataSourceRepository(DataSourcesClient(dio));

  final DataSourcesClient _client;

  @override
  Future<Result<List<DataSource>>> list() async {
    try {
      final output = (await _client.getApiDataSources()).data;

      return Success([
        for (final source in output?.sources ?? const <DataSourceOutput>[])
          DataSource(
            name: source.name ?? '',
            displayName: source.displayName ?? source.name ?? '',
            kind: SourceKind.from(source.kind),
            // Both read from the API. Whether a source works in this mode is
            // the instance's judgement, not a guess from the mode enum here.
            isAvailable: source.isAvailable ?? false,
            isNetworkBacked: source.isNetworkBacked ?? false,
            unavailableReason: source.unavailableReason,
            requiredInputs:
                source.requiredInputs?.whereType<String>().toList() ?? const [],
          ),
      ]);
    } on DioException catch (exception) {
      return failureFromDioException<List<DataSource>>(exception);
    }
  }
}

final dataSourceRepositoryProvider = Provider<DataSourceRepository>(
  (ref) => HttpDataSourceRepository.fromDio(ref.watch(dioProvider)),
);
