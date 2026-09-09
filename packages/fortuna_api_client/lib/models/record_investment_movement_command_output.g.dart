// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_movement_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentMovementCommandOutput
_$RecordInvestmentMovementCommandOutputFromJson(Map<String, dynamic> json) =>
    RecordInvestmentMovementCommandOutput(
      amount: (json['amount'] as num?)?.toDouble(),
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      financialAccountId: json['financialAccountId'] as String?,
      fundingAmount: (json['fundingAmount'] as num?)?.toDouble(),
      fundingCurrencyCode: json['fundingCurrencyCode'] as String?,
      id: json['id'] as String?,
      investmentId: json['investmentId'] as String?,
      movementType: json['movementType'] == null
          ? null
          : InvestmentMovementType.fromJson(
              (json['movementType'] as num).toInt(),
            ),
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      outboundTransactionId: json['outboundTransactionId'] as String?,
      position: (json['position'] as num?)?.toDouble(),
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      transferId: json['transferId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecordInvestmentMovementCommandOutputToJson(
  RecordInvestmentMovementCommandOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'appliedRate': instance.appliedRate,
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'financialAccountId': instance.financialAccountId,
  'fundingAmount': instance.fundingAmount,
  'fundingCurrencyCode': instance.fundingCurrencyCode,
  'id': instance.id,
  'investmentId': instance.investmentId,
  'movementType': instance.movementType,
  'occurredOn': instance.occurredOn?.toIso8601String(),
  'outboundTransactionId': instance.outboundTransactionId,
  'position': instance.position,
  'rateDate': instance.rateDate?.toIso8601String(),
  'transferId': instance.transferId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
