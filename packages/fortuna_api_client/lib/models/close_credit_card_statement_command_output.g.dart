// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_credit_card_statement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseCreditCardStatementCommandOutput
_$CloseCreditCardStatementCommandOutputFromJson(Map<String, dynamic> json) =>
    CloseCreditCardStatementCommandOutput(
      amountDue: (json['amountDue'] as num?)?.toDouble(),
      closingDate: json['closingDate'] == null
          ? null
          : DateTime.parse(json['closingDate'] as String),
      creditCardId: json['creditCardId'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      id: json['id'] as String?,
      periodEnd: json['periodEnd'] == null
          ? null
          : DateTime.parse(json['periodEnd'] as String),
      periodStart: json['periodStart'] == null
          ? null
          : DateTime.parse(json['periodStart'] as String),
      purchaseTotal: (json['purchaseTotal'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CloseCreditCardStatementCommandOutputToJson(
  CloseCreditCardStatementCommandOutput instance,
) => <String, dynamic>{
  'amountDue': instance.amountDue,
  'closingDate': instance.closingDate?.toIso8601String(),
  'creditCardId': instance.creditCardId,
  'dueDate': instance.dueDate?.toIso8601String(),
  'id': instance.id,
  'periodEnd': instance.periodEnd?.toIso8601String(),
  'periodStart': instance.periodStart?.toIso8601String(),
  'purchaseTotal': instance.purchaseTotal,
  'status': instance.status,
};
