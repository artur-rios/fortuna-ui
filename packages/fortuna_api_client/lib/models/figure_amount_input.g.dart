// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figure_amount_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FigureAmountInput _$FigureAmountInputFromJson(Map<String, dynamic> json) =>
    FigureAmountInput(
      amount: (json['amount'] as num?)?.toDouble(),
      currencyCode: json['currencyCode'] as String?,
    );

Map<String, dynamic> _$FigureAmountInputToJson(FigureAmountInput instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currencyCode': instance.currencyCode,
    };
