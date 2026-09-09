// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imports_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: type=lint
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main,avoid_redundant_argument_values

class _ImportsClient implements ImportsClient {
  _ImportsClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<ImportExcelWorkbookCommandOutputDataOutput> postApiImportsExcel({
    String? amountColumn,
    String? categoryColumn,
    bool? createMissingCategories,
    String? dateColumn,
    String? descriptionColumn,
    String? directionColumn,
    String? externalIdColumn,
    File? file,
    String? targetId,
    ImportTargetType? targetType,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (amountColumn != null) {
      _data.fields.add(MapEntry('AmountColumn', amountColumn));
    }
    if (categoryColumn != null) {
      _data.fields.add(MapEntry('CategoryColumn', categoryColumn));
    }
    if (createMissingCategories != null) {
      _data.fields.add(
        MapEntry('CreateMissingCategories', createMissingCategories.toString()),
      );
    }
    if (dateColumn != null) {
      _data.fields.add(MapEntry('DateColumn', dateColumn));
    }
    if (descriptionColumn != null) {
      _data.fields.add(MapEntry('DescriptionColumn', descriptionColumn));
    }
    if (directionColumn != null) {
      _data.fields.add(MapEntry('DirectionColumn', directionColumn));
    }
    if (externalIdColumn != null) {
      _data.fields.add(MapEntry('ExternalIdColumn', externalIdColumn));
    }
    if (file != null) {
      _data.files.add(
        MapEntry(
          'File',
          MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (targetId != null) {
      _data.fields.add(MapEntry('TargetId', targetId));
    }
    if (targetType != null) {
      _data.fields.add(MapEntry('TargetType', targetType.toString()));
    }
    final _options = _setStreamType<ImportExcelWorkbookCommandOutputDataOutput>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/imports/excel',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late ImportExcelWorkbookCommandOutputDataOutput _value;
    try {
      _value = ImportExcelWorkbookCommandOutputDataOutput.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<ImportPdfInvoiceCommandOutputDataOutput> postApiImportsPdf({
    String? creditCardId,
    File? file,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (creditCardId != null) {
      _data.fields.add(MapEntry('CreditCardId', creditCardId));
    }
    if (file != null) {
      _data.files.add(
        MapEntry(
          'File',
          MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _options = _setStreamType<ImportPdfInvoiceCommandOutputDataOutput>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/api/imports/pdf',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, Object?>>(_options);
    late ImportPdfInvoiceCommandOutputDataOutput _value;
    try {
      _value = ImportPdfInvoiceCommandOutputDataOutput.fromJson(_result.data!);
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
