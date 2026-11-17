// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figure_amount_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigureAmountInput _$FigureAmountInputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['amount', 'currencyCode'],
    disallowNullValues: const ['amount'],
  );
  return FigureAmountInput(
    amount: json['amount'] as String?,
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : FigureAmountInput._read_currencyCode(json['currencyCode']),
  );
}

Map<String, dynamic> _$FigureAmountInputToJson(FigureAmountInput instance) =>
    <String, dynamic>{
      'amount': ?instance.amount,
      if (instance.currencyCode case final $value?)
        'currencyCode': FigureAmountInput._write_currencyCode($value),
    };
