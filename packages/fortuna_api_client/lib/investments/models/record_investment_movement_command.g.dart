// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommand _$RecordInvestmentMovementCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'financialAccountId',
      'id',
      'movementType',
      'occurredOn',
    ],
    disallowNullValues: const ['amount', 'id', 'movementType', 'occurredOn'],
  );
  return RecordInvestmentMovementCommand(
    amount: json['amount'] as String?,
    financialAccountId: json['financialAccountId'] as String?,
    id: json['id'] as String?,
    movementType: RecordInvestmentMovementCommand._read_movementType(
      json['movementType'],
    ),
    occurredOn: json['occurredOn'] as String?,
  );
}

Map<String, dynamic> _$RecordInvestmentMovementCommandToJson(
  RecordInvestmentMovementCommand instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'financialAccountId': ?instance.financialAccountId,
  'id': ?instance.id,
  'movementType': ?RecordInvestmentMovementCommand._write_movementType(
    instance.movementType,
  ),
  'occurredOn': ?instance.occurredOn,
};
