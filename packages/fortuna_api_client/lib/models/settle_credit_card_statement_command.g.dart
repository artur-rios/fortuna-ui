// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommand _$SettleCreditCardStatementCommandFromJson(
  Map<String, dynamic> json,
) => SettleCreditCardStatementCommand(
  amount: json['amount'] as String?,
  financialAccountId: json['financialAccountId'] as String?,
  id: json['id'] as String?,
  paymentDate: json['paymentDate'] == null
      ? null
      : DateTime.parse(json['paymentDate'] as String),
);

Map<String, dynamic> _$SettleCreditCardStatementCommandToJson(
  SettleCreditCardStatementCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'financialAccountId': instance.financialAccountId,
  'id': instance.id,
  'paymentDate': instance.paymentDate?.toIso8601String(),
};
