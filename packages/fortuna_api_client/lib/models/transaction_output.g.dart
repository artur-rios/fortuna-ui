// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionOutput _$TransactionOutputFromJson(Map<String, dynamic> json) =>
    TransactionOutput(
      direction: json['direction'] == null
          ? null
          : TransactionDirection.fromJson((json['direction'] as num).toInt()),
      appliedRate: (json['appliedRate'] as num?)?.toDouble(),
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      counterpartyId: json['counterpartyId'] as String?,
      counterpartyName: json['counterpartyName'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      creditCardId: json['creditCardId'] as String?,
      creditCardName: json['creditCardName'] as String?,
      currencyCode: json['currencyCode'] as String?,
      description: json['description'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      financialAccountId: json['financialAccountId'] as String?,
      financialAccountName: json['financialAccountName'] as String?,
      id: json['id'] as String?,
      importJobId: json['importJobId'] as String?,
      importedAmount: (json['importedAmount'] as num?)?.toDouble(),
      importedOccurredOn: json['importedOccurredOn'] == null
          ? null
          : DateTime.parse(json['importedOccurredOn'] as String),
      importedRecordId: (json['importedRecordId'] as num?)?.toInt(),
      installmentNumber: (json['installmentNumber'] as num?)?.toInt(),
      installmentPlanId: json['installmentPlanId'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      isLateArriving: json['isLateArriving'] as bool?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isPossibleDuplicate: json['isPossibleDuplicate'] as bool?,
      isReconciled: json['isReconciled'] as bool?,
      isTransfer: json['isTransfer'] as bool?,
      occurredOn: json['occurredOn'] == null
          ? null
          : DateTime.parse(json['occurredOn'] as String),
      originalAmount: (json['originalAmount'] as num?)?.toDouble(),
      originalCurrencyCode: json['originalCurrencyCode'] as String?,
      rateDate: json['rateDate'] == null
          ? null
          : DateTime.parse(json['rateDate'] as String),
      recurringTransactionId: json['recurringTransactionId'] as String?,
      sourceType: json['sourceType'] == null
          ? null
          : TransactionSourceType.fromJson((json['sourceType'] as num).toInt()),
      statementId: json['statementId'] as String?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map(
            (e) => TransactionLabelOutput.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      isManuallyCorrected: json['isManuallyCorrected'] as bool?,
    );

Map<String, dynamic> _$TransactionOutputToJson(TransactionOutput instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'appliedRate': instance.appliedRate,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'counterpartyId': instance.counterpartyId,
      'counterpartyName': instance.counterpartyName,
      'createdAt': instance.createdAt?.toIso8601String(),
      'creditCardId': instance.creditCardId,
      'creditCardName': instance.creditCardName,
      'currencyCode': instance.currencyCode,
      'description': instance.description,
      'direction': instance.direction,
      'financialAccountId': instance.financialAccountId,
      'financialAccountName': instance.financialAccountName,
      'id': instance.id,
      'importJobId': instance.importJobId,
      'importedAmount': instance.importedAmount,
      'importedOccurredOn': instance.importedOccurredOn?.toIso8601String(),
      'importedRecordId': instance.importedRecordId,
      'installmentNumber': instance.installmentNumber,
      'installmentPlanId': instance.installmentPlanId,
      'isDeleted': instance.isDeleted,
      'isLateArriving': instance.isLateArriving,
      'isManuallyCorrected': instance.isManuallyCorrected,
      'isPossibleDuplicate': instance.isPossibleDuplicate,
      'isReconciled': instance.isReconciled,
      'isTransfer': instance.isTransfer,
      'occurredOn': instance.occurredOn?.toIso8601String(),
      'originalAmount': instance.originalAmount,
      'originalCurrencyCode': instance.originalCurrencyCode,
      'rateDate': instance.rateDate?.toIso8601String(),
      'recurringTransactionId': instance.recurringTransactionId,
      'sourceType': instance.sourceType,
      'statementId': instance.statementId,
      'tags': instance.tags,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
