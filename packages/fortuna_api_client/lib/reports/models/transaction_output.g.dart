// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionOutput _$TransactionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'amount',
      'appliedRate',
      'categoryId',
      'categoryName',
      'counterpartyId',
      'counterpartyName',
      'createdAt',
      'creditCardId',
      'creditCardName',
      'currencyCode',
      'description',
      'direction',
      'financialAccountId',
      'financialAccountName',
      'id',
      'importJobId',
      'importedAmount',
      'importedOccurredOn',
      'importedRecordId',
      'installmentNumber',
      'installmentPlanId',
      'isDeleted',
      'isLateArriving',
      'isManuallyCorrected',
      'isPossibleDuplicate',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'recurringTransactionId',
      'sourceType',
      'statementId',
      'tags',
      'updatedAt',
    ],
    disallowNullValues: const [
      'amount',
      'categoryId',
      'createdAt',
      'direction',
      'id',
      'isDeleted',
      'isLateArriving',
      'isManuallyCorrected',
      'isPossibleDuplicate',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'sourceType',
      'updatedAt',
    ],
  );
  return TransactionOutput(
    amount: json['amount'] as String?,
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TransactionOutput._read_appliedRate(json['appliedRate']),
    categoryId: json['categoryId'] as String?,
    categoryName: !json.containsKey('categoryName')
        ? null
        : TransactionOutput._read_categoryName(json['categoryName']),
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : TransactionOutput._read_counterpartyId(json['counterpartyId']),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : TransactionOutput._read_counterpartyName(json['counterpartyName']),
    createdAt: TransactionOutput._read_createdAt(json['createdAt']),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : TransactionOutput._read_creditCardId(json['creditCardId']),
    creditCardName: !json.containsKey('creditCardName')
        ? null
        : TransactionOutput._read_creditCardName(json['creditCardName']),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : TransactionOutput._read_currencyCode(json['currencyCode']),
    description: !json.containsKey('description')
        ? null
        : TransactionOutput._read_description(json['description']),
    direction: TransactionOutput._read_direction(json['direction']),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : TransactionOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    financialAccountName: !json.containsKey('financialAccountName')
        ? null
        : TransactionOutput._read_financialAccountName(
            json['financialAccountName'],
          ),
    id: json['id'] as String?,
    importJobId: !json.containsKey('importJobId')
        ? null
        : TransactionOutput._read_importJobId(json['importJobId']),
    importedAmount: !json.containsKey('importedAmount')
        ? null
        : TransactionOutput._read_importedAmount(json['importedAmount']),
    importedOccurredOn: !json.containsKey('importedOccurredOn')
        ? null
        : TransactionOutput._read_importedOccurredOn(
            json['importedOccurredOn'],
          ),
    importedRecordId: !json.containsKey('importedRecordId')
        ? null
        : TransactionOutput._read_importedRecordId(json['importedRecordId']),
    installmentNumber: !json.containsKey('installmentNumber')
        ? null
        : TransactionOutput._read_installmentNumber(json['installmentNumber']),
    installmentPlanId: !json.containsKey('installmentPlanId')
        ? null
        : TransactionOutput._read_installmentPlanId(json['installmentPlanId']),
    isDeleted: json['isDeleted'] as bool?,
    isLateArriving: json['isLateArriving'] as bool?,
    isManuallyCorrected: json['isManuallyCorrected'] as bool?,
    isPossibleDuplicate: json['isPossibleDuplicate'] as bool?,
    isReconciled: json['isReconciled'] as bool?,
    isTransfer: json['isTransfer'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : TransactionOutput._read_originalAmount(json['originalAmount']),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : TransactionOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : TransactionOutput._read_rateDate(json['rateDate']),
    recurringTransactionId: !json.containsKey('recurringTransactionId')
        ? null
        : TransactionOutput._read_recurringTransactionId(
            json['recurringTransactionId'],
          ),
    sourceType: TransactionOutput._read_sourceType(json['sourceType']),
    statementId: !json.containsKey('statementId')
        ? null
        : TransactionOutput._read_statementId(json['statementId']),
    tags: !json.containsKey('tags')
        ? null
        : TransactionOutput._read_tags(json['tags']),
    updatedAt: TransactionOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$TransactionOutputToJson(
  TransactionOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': TransactionOutput._write_appliedRate($value),
  'categoryId': ?instance.categoryId,
  if (instance.categoryName case final $value?)
    'categoryName': TransactionOutput._write_categoryName($value),
  if (instance.counterpartyId case final $value?)
    'counterpartyId': TransactionOutput._write_counterpartyId($value),
  if (instance.counterpartyName case final $value?)
    'counterpartyName': TransactionOutput._write_counterpartyName($value),
  'createdAt': ?TransactionOutput._write_createdAt(instance.createdAt),
  if (instance.creditCardId case final $value?)
    'creditCardId': TransactionOutput._write_creditCardId($value),
  if (instance.creditCardName case final $value?)
    'creditCardName': TransactionOutput._write_creditCardName($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': TransactionOutput._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': TransactionOutput._write_description($value),
  'direction': ?TransactionOutput._write_direction(instance.direction),
  if (instance.financialAccountId case final $value?)
    'financialAccountId': TransactionOutput._write_financialAccountId($value),
  if (instance.financialAccountName case final $value?)
    'financialAccountName': TransactionOutput._write_financialAccountName(
      $value,
    ),
  'id': ?instance.id,
  if (instance.importJobId case final $value?)
    'importJobId': TransactionOutput._write_importJobId($value),
  if (instance.importedAmount case final $value?)
    'importedAmount': TransactionOutput._write_importedAmount($value),
  if (instance.importedOccurredOn case final $value?)
    'importedOccurredOn': TransactionOutput._write_importedOccurredOn($value),
  if (instance.importedRecordId case final $value?)
    'importedRecordId': TransactionOutput._write_importedRecordId($value),
  if (instance.installmentNumber case final $value?)
    'installmentNumber': TransactionOutput._write_installmentNumber($value),
  if (instance.installmentPlanId case final $value?)
    'installmentPlanId': TransactionOutput._write_installmentPlanId($value),
  'isDeleted': ?instance.isDeleted,
  'isLateArriving': ?instance.isLateArriving,
  'isManuallyCorrected': ?instance.isManuallyCorrected,
  'isPossibleDuplicate': ?instance.isPossibleDuplicate,
  'isReconciled': ?instance.isReconciled,
  'isTransfer': ?instance.isTransfer,
  'occurredOn': ?instance.occurredOn,
  if (instance.originalAmount case final $value?)
    'originalAmount': TransactionOutput._write_originalAmount($value),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode': TransactionOutput._write_originalCurrencyCode(
      $value,
    ),
  if (instance.rateDate case final $value?)
    'rateDate': TransactionOutput._write_rateDate($value),
  if (instance.recurringTransactionId case final $value?)
    'recurringTransactionId': TransactionOutput._write_recurringTransactionId(
      $value,
    ),
  'sourceType': ?TransactionOutput._write_sourceType(instance.sourceType),
  if (instance.statementId case final $value?)
    'statementId': TransactionOutput._write_statementId($value),
  if (instance.tags case final $value?)
    'tags': TransactionOutput._write_tags($value),
  'updatedAt': ?TransactionOutput._write_updatedAt(instance.updatedAt),
};
