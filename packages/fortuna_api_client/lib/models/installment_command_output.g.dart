// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentCommandOutput _$InstallmentCommandOutputFromJson(
  Map<String, dynamic> json,
) => InstallmentCommandOutput(
  amount: (json['amount'] as num?)?.toDouble(),
  appliedRate: (json['appliedRate'] as num?)?.toDouble(),
  currencyCode: json['currencyCode'] as String?,
  isLateArriving: json['isLateArriving'] as bool?,
  number: (json['number'] as num?)?.toInt(),
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
  originalAmount: (json['originalAmount'] as num?)?.toDouble(),
  originalCurrencyCode: json['originalCurrencyCode'] as String?,
  rateDate: json['rateDate'] == null
      ? null
      : DateTime.parse(json['rateDate'] as String),
  statementId: json['statementId'] as String?,
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$InstallmentCommandOutputToJson(
  InstallmentCommandOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'appliedRate': instance.appliedRate,
  'currencyCode': instance.currencyCode,
  'isLateArriving': instance.isLateArriving,
  'number': instance.number,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'originalAmount': instance.originalAmount,
  'originalCurrencyCode': instance.originalCurrencyCode,
  'rateDate': instance.rateDate?.toIso8601String(),
  'statementId': instance.statementId,
  'transactionId': instance.transactionId,
};
