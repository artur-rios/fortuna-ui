// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferOutput _$TransferOutputFromJson(Map<String, dynamic> json) =>
    TransferOutput(
      appliedRate: json['appliedRate'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      destinationCreditCardId: json['destinationCreditCardId'] as String?,
      destinationFinancialAccountId:
          json['destinationFinancialAccountId'] as String?,
      destinationInvestmentId: json['destinationInvestmentId'] as String?,
      destinationStatementId: json['destinationStatementId'] as String?,
      id: json['id'] as String?,
      inboundAmount: json['inboundAmount'] as String?,
      inboundCurrencyCode: json['inboundCurrencyCode'] as String?,
      inboundInvestmentMovementId:
          json['inboundInvestmentMovementId'] as String?,
      inboundIsDeleted: json['inboundIsDeleted'] as bool?,
      inboundTransactionId: json['inboundTransactionId'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      originFinancialAccountId: json['originFinancialAccountId'] as String?,
      outboundAmount: json['outboundAmount'] as String?,
      outboundCurrencyCode: json['outboundCurrencyCode'] as String?,
      outboundIsDeleted: json['outboundIsDeleted'] as bool?,
      outboundTransactionId: json['outboundTransactionId'] as String?,
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransferOutputToJson(TransferOutput instance) =>
    <String, dynamic>{
      'appliedRate': instance.appliedRate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'destinationCreditCardId': instance.destinationCreditCardId,
      'destinationFinancialAccountId': instance.destinationFinancialAccountId,
      'destinationInvestmentId': instance.destinationInvestmentId,
      'destinationStatementId': instance.destinationStatementId,
      'id': instance.id,
      'inboundAmount': instance.inboundAmount,
      'inboundCurrencyCode': instance.inboundCurrencyCode,
      'inboundInvestmentMovementId': instance.inboundInvestmentMovementId,
      'inboundIsDeleted': instance.inboundIsDeleted,
      'inboundTransactionId': instance.inboundTransactionId,
      'isDeleted': instance.isDeleted,
      'occurredOn': instance.occurredOn?.toIso8601String(),
      'originFinancialAccountId': instance.originFinancialAccountId,
      'outboundAmount': instance.outboundAmount,
      'outboundCurrencyCode': instance.outboundCurrencyCode,
      'outboundIsDeleted': instance.outboundIsDeleted,
      'outboundTransactionId': instance.outboundTransactionId,
      'rateDate': instance.rateDate?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
