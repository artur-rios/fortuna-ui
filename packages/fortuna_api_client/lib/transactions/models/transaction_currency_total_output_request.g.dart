// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_currency_total_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCurrencyTotalOutput$Request
_$TransactionCurrencyTotalOutput$RequestFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'appliedRate',
      'currencyCode',
      'displayCurrencyCode',
      'displayEarning',
      'displayExpense',
      'displayNet',
      'earning',
      'expense',
      'rateDate',
      'rateSource',
      'unconvertedReason',
    ],
    disallowNullValues: const ['earning', 'expense', 'rateSource'],
  );
  return TransactionCurrencyTotalOutput$Request(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_appliedRate(
            json['appliedRate'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_currencyCode(
            json['currencyCode'],
          ),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    displayEarning: !json.containsKey('displayEarning')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_displayEarning(
            json['displayEarning'],
          ),
    displayExpense: !json.containsKey('displayExpense')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_displayExpense(
            json['displayExpense'],
          ),
    displayNet: !json.containsKey('displayNet')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_displayNet(
            json['displayNet'],
          ),
    earning: json['earning'] as String?,
    expense: json['expense'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_rateDate(
            json['rateDate'],
          ),
    rateSource: TransactionCurrencyTotalOutput$Request._read_rateSource(
      json['rateSource'],
    ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : TransactionCurrencyTotalOutput$Request._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$TransactionCurrencyTotalOutput$RequestToJson(
  TransactionCurrencyTotalOutput$Request instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': TransactionCurrencyTotalOutput$Request._write_appliedRate(
      $value,
    ),
  if (instance.currencyCode case final $value?)
    'currencyCode': TransactionCurrencyTotalOutput$Request._write_currencyCode(
      $value,
    ),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        TransactionCurrencyTotalOutput$Request._write_displayCurrencyCode(
          $value,
        ),
  if (instance.displayEarning case final $value?)
    'displayEarning':
        TransactionCurrencyTotalOutput$Request._write_displayEarning($value),
  if (instance.displayExpense case final $value?)
    'displayExpense':
        TransactionCurrencyTotalOutput$Request._write_displayExpense($value),
  if (instance.displayNet case final $value?)
    'displayNet': TransactionCurrencyTotalOutput$Request._write_displayNet(
      $value,
    ),
  'earning': ?instance.earning,
  'expense': ?instance.expense,
  if (instance.rateDate case final $value?)
    'rateDate': TransactionCurrencyTotalOutput$Request._write_rateDate($value),
  'rateSource': ?TransactionCurrencyTotalOutput$Request._write_rateSource(
    instance.rateSource,
  ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason':
        TransactionCurrencyTotalOutput$Request._write_unconvertedReason($value),
};
