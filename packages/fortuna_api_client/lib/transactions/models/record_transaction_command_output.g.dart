// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transaction_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordTransactionCommandOutput _$RecordTransactionCommandOutputFromJson(
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
      'currencyCode',
      'description',
      'direction',
      'financialAccountId',
      'id',
      'isLateArriving',
      'occurredOn',
      'originalAmount',
      'originalCurrencyCode',
      'rateDate',
      'statementClosingDate',
      'statementDueDate',
      'statementId',
      'statementPeriodEnd',
      'statementPeriodStart',
      'statementPurchaseTotal',
      'statementStatus',
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
      'occurredOn',
      'updatedAt',
    ],
  );
  return RecordTransactionCommandOutput(
    amount: json['amount'] as String?,
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : RecordTransactionCommandOutput._read_appliedRate(json['appliedRate']),
    categoryId: json['categoryId'] as String?,
    categoryName: !json.containsKey('categoryName')
        ? null
        : RecordTransactionCommandOutput._read_categoryName(
            json['categoryName'],
          ),
    counterpartyId: !json.containsKey('counterpartyId')
        ? null
        : RecordTransactionCommandOutput._read_counterpartyId(
            json['counterpartyId'],
          ),
    counterpartyName: !json.containsKey('counterpartyName')
        ? null
        : RecordTransactionCommandOutput._read_counterpartyName(
            json['counterpartyName'],
          ),
    createdAt: RecordTransactionCommandOutput._read_createdAt(
      json['createdAt'],
    ),
    creditCardId: !json.containsKey('creditCardId')
        ? null
        : RecordTransactionCommandOutput._read_creditCardId(
            json['creditCardId'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : RecordTransactionCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    description: !json.containsKey('description')
        ? null
        : RecordTransactionCommandOutput._read_description(json['description']),
    direction: RecordTransactionCommandOutput._read_direction(
      json['direction'],
    ),
    financialAccountId: !json.containsKey('financialAccountId')
        ? null
        : RecordTransactionCommandOutput._read_financialAccountId(
            json['financialAccountId'],
          ),
    id: json['id'] as String?,
    isLateArriving: json['isLateArriving'] as bool?,
    occurredOn: json['occurredOn'] as String?,
    originalAmount: !json.containsKey('originalAmount')
        ? null
        : RecordTransactionCommandOutput._read_originalAmount(
            json['originalAmount'],
          ),
    originalCurrencyCode: !json.containsKey('originalCurrencyCode')
        ? null
        : RecordTransactionCommandOutput._read_originalCurrencyCode(
            json['originalCurrencyCode'],
          ),
    rateDate: !json.containsKey('rateDate')
        ? null
        : RecordTransactionCommandOutput._read_rateDate(json['rateDate']),
    statementClosingDate: !json.containsKey('statementClosingDate')
        ? null
        : RecordTransactionCommandOutput._read_statementClosingDate(
            json['statementClosingDate'],
          ),
    statementDueDate: !json.containsKey('statementDueDate')
        ? null
        : RecordTransactionCommandOutput._read_statementDueDate(
            json['statementDueDate'],
          ),
    statementId: !json.containsKey('statementId')
        ? null
        : RecordTransactionCommandOutput._read_statementId(json['statementId']),
    statementPeriodEnd: !json.containsKey('statementPeriodEnd')
        ? null
        : RecordTransactionCommandOutput._read_statementPeriodEnd(
            json['statementPeriodEnd'],
          ),
    statementPeriodStart: !json.containsKey('statementPeriodStart')
        ? null
        : RecordTransactionCommandOutput._read_statementPeriodStart(
            json['statementPeriodStart'],
          ),
    statementPurchaseTotal: !json.containsKey('statementPurchaseTotal')
        ? null
        : RecordTransactionCommandOutput._read_statementPurchaseTotal(
            json['statementPurchaseTotal'],
          ),
    statementStatus: !json.containsKey('statementStatus')
        ? null
        : RecordTransactionCommandOutput._read_statementStatus(
            json['statementStatus'],
          ),
    tags: !json.containsKey('tags')
        ? null
        : RecordTransactionCommandOutput._read_tags(json['tags']),
    updatedAt: RecordTransactionCommandOutput._read_updatedAt(
      json['updatedAt'],
    ),
  );
}

Map<String, dynamic> _$RecordTransactionCommandOutputToJson(
  RecordTransactionCommandOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  if (instance.appliedRate case final $value?)
    'appliedRate': RecordTransactionCommandOutput._write_appliedRate($value),
  'categoryId': ?instance.categoryId,
  if (instance.categoryName case final $value?)
    'categoryName': RecordTransactionCommandOutput._write_categoryName($value),
  if (instance.counterpartyId case final $value?)
    'counterpartyId': RecordTransactionCommandOutput._write_counterpartyId(
      $value,
    ),
  if (instance.counterpartyName case final $value?)
    'counterpartyName': RecordTransactionCommandOutput._write_counterpartyName(
      $value,
    ),
  'createdAt': ?RecordTransactionCommandOutput._write_createdAt(
    instance.createdAt,
  ),
  if (instance.creditCardId case final $value?)
    'creditCardId': RecordTransactionCommandOutput._write_creditCardId($value),
  if (instance.currencyCode case final $value?)
    'currencyCode': RecordTransactionCommandOutput._write_currencyCode($value),
  if (instance.description case final $value?)
    'description': RecordTransactionCommandOutput._write_description($value),
  'direction': ?RecordTransactionCommandOutput._write_direction(
    instance.direction,
  ),
  if (instance.financialAccountId case final $value?)
    'financialAccountId':
        RecordTransactionCommandOutput._write_financialAccountId($value),
  'id': ?instance.id,
  'isLateArriving': ?instance.isLateArriving,
  'occurredOn': ?instance.occurredOn,
  if (instance.originalAmount case final $value?)
    'originalAmount': RecordTransactionCommandOutput._write_originalAmount(
      $value,
    ),
  if (instance.originalCurrencyCode case final $value?)
    'originalCurrencyCode':
        RecordTransactionCommandOutput._write_originalCurrencyCode($value),
  if (instance.rateDate case final $value?)
    'rateDate': RecordTransactionCommandOutput._write_rateDate($value),
  if (instance.statementClosingDate case final $value?)
    'statementClosingDate':
        RecordTransactionCommandOutput._write_statementClosingDate($value),
  if (instance.statementDueDate case final $value?)
    'statementDueDate': RecordTransactionCommandOutput._write_statementDueDate(
      $value,
    ),
  if (instance.statementId case final $value?)
    'statementId': RecordTransactionCommandOutput._write_statementId($value),
  if (instance.statementPeriodEnd case final $value?)
    'statementPeriodEnd':
        RecordTransactionCommandOutput._write_statementPeriodEnd($value),
  if (instance.statementPeriodStart case final $value?)
    'statementPeriodStart':
        RecordTransactionCommandOutput._write_statementPeriodStart($value),
  if (instance.statementPurchaseTotal case final $value?)
    'statementPurchaseTotal':
        RecordTransactionCommandOutput._write_statementPurchaseTotal($value),
  if (instance.statementStatus case final $value?)
    'statementStatus': RecordTransactionCommandOutput._write_statementStatus(
      $value,
    ),
  if (instance.tags case final $value?)
    'tags': RecordTransactionCommandOutput._write_tags($value),
  'updatedAt': ?RecordTransactionCommandOutput._write_updatedAt(
    instance.updatedAt,
  ),
};
