// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_credit_card_statement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloseCreditCardStatementCommandOutput
_$CloseCreditCardStatementCommandOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amountDue',
      'closingDate',
      'creditCardId',
      'dueDate',
      'id',
      'periodEnd',
      'periodStart',
      'purchaseTotal',
      'status',
    ],
    disallowNullValues: const [
      'amountDue',
      'closingDate',
      'creditCardId',
      'dueDate',
      'id',
      'periodEnd',
      'periodStart',
      'purchaseTotal',
    ],
  );
  return CloseCreditCardStatementCommandOutput(
    amountDue: json['amountDue'] as String?,
    closingDate: json['closingDate'] as String?,
    creditCardId: json['creditCardId'] as String?,
    dueDate: json['dueDate'] as String?,
    id: json['id'] as String?,
    periodEnd: json['periodEnd'] as String?,
    periodStart: json['periodStart'] as String?,
    purchaseTotal: json['purchaseTotal'] as String?,
    status: !json.containsKey('status')
        ? null
        : CloseCreditCardStatementCommandOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$CloseCreditCardStatementCommandOutputToJson(
  CloseCreditCardStatementCommandOutput instance,
) => <String, dynamic>{
  'amountDue': ?instance.amountDue,
  'closingDate': ?instance.closingDate,
  'creditCardId': ?instance.creditCardId,
  'dueDate': ?instance.dueDate,
  'id': ?instance.id,
  'periodEnd': ?instance.periodEnd,
  'periodStart': ?instance.periodStart,
  'purchaseTotal': ?instance.purchaseTotal,
  if (instance.status case final $value?)
    'status': CloseCreditCardStatementCommandOutput._write_status($value),
};
