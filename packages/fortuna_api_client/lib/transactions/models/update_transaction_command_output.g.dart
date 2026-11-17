// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTransactionCommandOutput _$UpdateTransactionCommandOutputFromJson(
  Map<String, dynamic> json,
) {
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
      'isLateArriving',
      'isManuallyCorrected',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
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
      'isLateArriving',
      'isManuallyCorrected',
      'isReconciled',
      'isTransfer',
      'occurredOn',
      'sourceType',
      'updatedAt',
    ],
  );
  return UpdateTransactionCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : UpdateTransactionCommandOutput._read_appliedRate(json['appliedRate']),
    categoryId: json['categoryId'] as String?,
    categoryName: !json.containsKey('categoryName')
        ? null
        : UpdateTransactionCommandOutput._read_categoryName(
            json['categoryName'],
          ),
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : UpdateTransactionCommandOutput._read_counterpartyId(
            json['counterpartyId'],
          ),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : UpdateTransactionCommandOutput._read_counterpartyName(
            json['counterpartyName'],
          ),
    createdAt: UpdateTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : UpdateTransactionCommandOutput._read_creditCardId(
            json['creditCardId'],
          ),
    creditCardName: !json.containsKey('creditCardName')
        ? null
        : UpdateTransactionCommandOutput._read_creditCardName(
            json['creditCardName'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateTransactionCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    description: !json.containsKey('description')
        ? null
        : UpdateTransactionCommandOutput._read_description(json['description']),
    direction: UpdateTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : UpdateTransactionCommandOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    financialAccountName: !json.containsKey('financialAccountName')
        ? null
        : UpdateTransactionCommandOutput._read_financialAccountName(
            json['financialAccountName'],
          ),
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    isManuallyCorrected: json['isManuallyCorrected'] as bool?,
    isReconciled: json['isReconciled'] as bool?,
    isTransfer: json['isTransfer'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : UpdateTransactionCommandOutput._read_originalAmount(
            json['originalAmount'],
          ),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : UpdateTransactionCommandOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : UpdateTransactionCommandOutput._read_rateDate(json['rateDate']),
    sourceType: UpdateTransactionCommandOutput._read_sourceType(
      json['sourceType'],
    ),
    statementId: !json.containsKey('statementId')
        ? null
        : UpdateTransactionCommandOutput._read_statementId(json['statementId']),
    tags: !json.containsKey('tags')
        ? null
        : UpdateTransactionCommandOutput._read_tags(json['tags']),
    updatedAt: UpdateTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$UpdateTransactionCommandOutputToJson(
  UpdateTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': UpdateTransactionCommandOutput._write_appliedRate($value),
  'categoryId': ?instance.categoryId,
  if (instance.categoryName case final $value?)
    'categoryName': UpdateTransactionCommandOutput._write_categoryName($value),
  if (instance.counterpartyId case final $value?)
    'counterpartyId': UpdateTransactionCommandOutput._write_counterpartyId(
      $value,
    ),
  if (instance.counterpartyName case final $value?)
    'counterpartyName': UpdateTransactionCommandOutput._write_counterpartyName(
      $value,
    ),
  'createdAt': ?UpdateTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.creditCardId case final $value?)
    'creditCardId': UpdateTransactionCommandOutput._write_creditCardId($value),
  if (instance.creditCardName case final $value?)
    'creditCardName': UpdateTransactionCommandOutput._write_creditCardName(
      $value,
    ),
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateTransactionCommandOutput._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': UpdateTransactionCommandOutput._write_description($value),
  'direction': ?UpdateTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        UpdateTransactionCommandOutput._write_financialAccountId($value),
  if (instance.financialAccountName case final $value?)
    'financialAccountName':
        UpdateTransactionCommandOutput._write_financialAccountName($value),
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'isManuallyCorrected': ?instance.isManuallyCorrected,
  'isReconciled': ?instance.isReconciled,
  'isTransfer': ?instance.isTransfer,
  'occurredOn': ?instance.occurredOn,
  if (instance.originalAmount case final $value?)
    'originalAmount': UpdateTransactionCommandOutput._write_originalAmount(
      $value,
    ),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode':
        UpdateTransactionCommandOutput._write_originalCurrencyCode($value),
  if (instance.rateDate case final $value?)
    'rateDate': UpdateTransactionCommandOutput._write_rateDate($value),
  'sourceType': ?UpdateTransactionCommandOutput._write_sourceType(
    instance.sourceType,
  ),
  if (instance.statementId case final $value?)
    'statementId': UpdateTransactionCommandOutput._write_statementId($value),
  if (instance.tags case final $value?)
    'tags': UpdateTransactionCommandOutput._write_tags($value),
  'updatedAt': ?UpdateTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
