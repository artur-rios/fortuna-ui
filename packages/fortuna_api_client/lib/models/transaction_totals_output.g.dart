// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_totals_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionTotalsOutput _$TransactionTotalsOutputFromJson(
  Map<String, dynamic> json,
) => TransactionTotalsOutput(
  byCurrency: (json['byCurrency'] as List<dynamic>?)
      ?.map(
        (e) =>
            TransactionCurrencyTotalOutput.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  displayCurrencyCode: json['displayCurrencyCode'] as String?,
  displayEarning: (json['displayEarning'] as num?)?.toDouble(),
  displayExpense: (json['displayExpense'] as num?)?.toDouble(),
  displayNet: (json['displayNet'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TransactionTotalsOutputToJson(
  TransactionTotalsOutput instance,
) => <String, dynamic>{
  'byCurrency': instance.byCurrency,
  'displayCurrencyCode': instance.displayCurrencyCode,
  'displayEarning': instance.displayEarning,
  'displayExpense': instance.displayExpense,
  'displayNet': instance.displayNet,
};
