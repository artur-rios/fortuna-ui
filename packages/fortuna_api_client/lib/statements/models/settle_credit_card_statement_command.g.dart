// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settle_credit_card_statement_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettleCreditCardStatementCommand _$SettleCreditCardStatementCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['amount', 'financialAccountId', 'id', 'paymentDate'],
    disallowNullValues: const [
      'amount',
      'financialAccountId',
      'id',
      'paymentDate',
    ],
  );
  return SettleCreditCardStatementCommand(
    amount: json['amount'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    id: json['id'] as String?,
    paymentDate: json['paymentDate'] as String?,
  );
}

Map<String, dynamic> _$SettleCreditCardStatementCommandToJson(
  SettleCreditCardStatementCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'financialAccountId': ?instance.financialAccountId,
  'id': ?instance.id,
  'paymentDate': ?instance.paymentDate,
};
