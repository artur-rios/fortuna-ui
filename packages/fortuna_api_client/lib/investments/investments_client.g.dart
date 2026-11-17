// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investments_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _InvestmentsClient extends InvestmentsClient {
  _InvestmentsClient._(
    this._dio,
    Dio _transport, {
    this.baseUrl,
    this.errorLogger,
  }) : super._(_transport);

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<CreateInvestmentCommandOutputDataOutput$Response> postApiInvestments({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required CreateInvestmentCommand body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<CreateInvestmentCommandOutputDataOutput$Response>(
          Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json',
              )
              .compose(
                _dio.options,
                '/api/investments',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late CreateInvestmentCommandOutputDataOutput$Response _value;
    try {
      _value = CreateInvestmentCommandOutputDataOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InvestmentOutputDataOutput$Response> getApiInvestmentsById({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    String? displayCurrencyCode,
    String? figureDate,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{
      r'displayCurrencyCode': displayCurrencyCode,
      r'figureDate': figureDate,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<InvestmentOutputDataOutput$Response>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/api/investments/${id}',
            queryParameters: queryParameters,
            data: _data,
            cancelToken: cancelToken,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late InvestmentOutputDataOutput$Response _value;
    try {
      _value = InvestmentOutputDataOutput$Response.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UpdateInvestmentCommandOutputDataOutput$Response>
  putApiInvestmentsById({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required UpdateInvestmentCommand body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<UpdateInvestmentCommandOutputDataOutput$Response>(
          Options(
                method: 'PUT',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json',
              )
              .compose(
                _dio.options,
                '/api/investments/${id}',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late UpdateInvestmentCommandOutputDataOutput$Response _value;
    try {
      _value = UpdateInvestmentCommandOutputDataOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InvestmentLifecycleCommandOutputDataOutput$Response>
  deleteApiInvestmentsById({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<InvestmentLifecycleCommandOutputDataOutput$Response>(
          Options(method: 'DELETE', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/investments/${id}',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late InvestmentLifecycleCommandOutputDataOutput$Response _value;
    try {
      _value = InvestmentLifecycleCommandOutputDataOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InvestmentLifecycleCommandOutputDataOutput$Response>
  deleteApiInvestmentsByIdHard({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<InvestmentLifecycleCommandOutputDataOutput$Response>(
          Options(method: 'DELETE', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/investments/${id}/hard',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late InvestmentLifecycleCommandOutputDataOutput$Response _value;
    try {
      _value = InvestmentLifecycleCommandOutputDataOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RecordInvestmentMovementCommandOutputDataOutput$Response>
  postApiInvestmentsByIdMovements({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required RecordInvestmentMovementCommand body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<
          RecordInvestmentMovementCommandOutputDataOutput$Response
        >(
          Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json',
              )
              .compose(
                _dio.options,
                '/api/investments/${id}/movements',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late RecordInvestmentMovementCommandOutputDataOutput$Response _value;
    try {
      _value =
          RecordInvestmentMovementCommandOutputDataOutput$Response.fromJson(
            _result.data!,
          );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InvestmentLifecycleCommandOutputDataOutput$Response>
  postApiInvestmentsByIdRestore({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<InvestmentLifecycleCommandOutputDataOutput$Response>(
          Options(method: 'POST', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/investments/${id}/restore',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late InvestmentLifecycleCommandOutputDataOutput$Response _value;
    try {
      _value = InvestmentLifecycleCommandOutputDataOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InvestmentValuationOutputPaginatedOutput$Response>
  getApiInvestmentsByIdValuations({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    String? investmentId,
    String? from,
    String? to,
    String? sortBy,
    bool? descending,
    int? pageNumber,
    int? pageSize,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{
      r'InvestmentId': investmentId,
      r'From': from,
      r'To': to,
      r'SortBy': sortBy,
      r'Descending': descending,
      r'PageNumber': pageNumber,
      r'PageSize': pageSize,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Accept': 'application/json'};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options =
        _setStreamType<InvestmentValuationOutputPaginatedOutput$Response>(
          Options(method: 'GET', headers: _headers, extra: _extra)
              .compose(
                _dio.options,
                '/api/investments/${id}/valuations',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late InvestmentValuationOutputPaginatedOutput$Response _value;
    try {
      _value = InvestmentValuationOutputPaginatedOutput$Response.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<RecordInvestmentValuationCommandOutputDataOutput$Response>
  postApiInvestmentsByIdValuations({
    Map<String, Object?> extra = const {
      "openapi.security": [{}],
      "openapi.securitySchemes": {},
    },
    CancelToken? cancelToken,
    Options? options,
    required String id,
    required RecordInvestmentValuationCommand body,
  }) async {
    final _extra = <String, dynamic>{};
    _extra.addAll(extra);
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body.toJson());
    final _options =
        _setStreamType<
          RecordInvestmentValuationCommandOutputDataOutput$Response
        >(
          Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'application/json',
              )
              .compose(
                _dio.options,
                '/api/investments/${id}/valuations',
                queryParameters: queryParameters,
                data: _data,
                cancelToken: cancelToken,
              )
              .copyWith(
                baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
              ),
        );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late RecordInvestmentValuationCommandOutputDataOutput$Response _value;
    try {
      _value =
          RecordInvestmentValuationCommandOutputDataOutput$Response.fromJson(
            _result.data!,
          );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
