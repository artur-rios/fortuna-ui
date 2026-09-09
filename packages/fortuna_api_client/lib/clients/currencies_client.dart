// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/currency_output_data_output.dart';
import '../models/list_supported_currencies_query_output_data_output.dart';

part 'currencies_client.g.dart';

@RestApi()
abstract class CurrenciesClient {
  factory CurrenciesClient(Dio dio, {String? baseUrl}) = _CurrenciesClient;

  @GET('/api/currencies')
  Future<ListSupportedCurrenciesQueryOutputDataOutput> getApiCurrencies();

  @GET('/api/currencies/{code}')
  Future<CurrencyOutputDataOutput> getApiCurrenciesCode({
    @Path('code') required String code,
  });
}
