// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommand _$RecordInvestmentMovementCommandFromJson(
  Map<String, dynamic> json,
) => RecordInvestmentMovementCommand(
  amount: (json['amount'] as num?)?.toDouble(),
  financialAccountId: json['financialAccountId'] as String?,
  id: json['id'] as String?,
  movementType: json['movementType'] == null
      ? null
      : InvestmentMovementType.fromJson((json['movementType'] as num).toInt()),
  occurredOn: json['occurredOn'] == null
      ? null
      : DateTime.parse(json['occurredOn'] as String),
);

Map<String, dynamic> _$RecordInvestmentMovementCommandToJson(
  RecordInvestmentMovementCommand instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'financialAccountId': instance.financialAccountId,
  'id': instance.id,
  'movementType': instance.movementType,
  'occurredOn': instance.occurredOn?.toIso8601String(),
};
