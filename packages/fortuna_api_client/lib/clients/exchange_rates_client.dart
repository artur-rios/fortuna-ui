// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/convert_figure_query.dart';
import '../models/convert_figure_query_output_data_output.dart';
import '../models/record_manual_exchange_rate_command.dart';
import '../models/record_manual_exchange_rate_command_output_data_output.dart';
import '../models/synchronize_exchange_rates_command.dart';
import '../models/synchronize_exchange_rates_command_output_data_output.dart';

part 'exchange_rates_client.g.dart';

@RestApi()
abstract class ExchangeRatesClient {
  factory ExchangeRatesClient(Dio dio, {String? baseUrl}) =
      _ExchangeRatesClient;

  @POST('/api/exchange-rates')
  Future<RecordManualExchangeRateCommandOutputDataOutput> postApiExchangeRates({
    @Body() RecordManualExchangeRateCommand? body,
  });

  @POST('/api/exchange-rates/convert')
  Future<ConvertFigureQueryOutputDataOutput> postApiExchangeRatesConvert({
    @Body() ConvertFigureQuery? body,
  });

  @POST('/api/exchange-rates/sync')
  Future<SynchronizeExchangeRatesCommandOutputDataOutput>
  postApiExchangeRatesSync({@Body() SynchronizeExchangeRatesCommand? body});
}
