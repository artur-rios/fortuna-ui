// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_currency_total_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCurrencyTotalOutput$Response
_$TransactionCurrencyTotalOutput$ResponseFromJson(Map<String, dynamic> json) {
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
      'net',
      'rateDate',
      'rateSource',
      'unconvertedReason',
    ],
    disallowNullValues: const ['earning', 'expense', 'net', 'rateSource'],
  );
  return TransactionCurrencyTotalOutput$Response(
    appliedRate: !json.containsKey('appliedRate')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_appliedRate(
            json['appliedRate'],
          ),
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_currencyCode(
            json['currencyCode'],
          ),
    displayCurrencyCode: !json.containsKey('displayCurrencyCode')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_displayCurrencyCode(
            json['displayCurrencyCode'],
          ),
    displayEarning: !json.containsKey('displayEarning')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_displayEarning(
            json['displayEarning'],
          ),
    displayExpense: !json.containsKey('displayExpense')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_displayExpense(
            json['displayExpense'],
          ),
    displayNet: !json.containsKey('displayNet')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_displayNet(
            json['displayNet'],
          ),
    earning: json['earning'] as String?,
    expense: json['expense'] as String?,
    net: json['net'] as String?,
    rateDate: !json.containsKey('rateDate')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_rateDate(
            json['rateDate'],
          ),
    rateSource: TransactionCurrencyTotalOutput$Response._read_rateSource(
      json['rateSource'],
    ),
    unconvertedReason: !json.containsKey('unconvertedReason')
        ? null
        : TransactionCurrencyTotalOutput$Response._read_unconvertedReason(
            json['unconvertedReason'],
          ),
  );
}

Map<String, dynamic> _$TransactionCurrencyTotalOutput$ResponseToJson(
  TransactionCurrencyTotalOutput$Response instance,
) => <String, dynamic>{
  if (instance.appliedRate case final $value?)
    'appliedRate': TransactionCurrencyTotalOutput$Response._write_appliedRate(
      $value,
    ),
  if (instance.currencyCode case final $value?)
    'currencyCode': TransactionCurrencyTotalOutput$Response._write_currencyCode(
      $value,
    ),
  if (instance.displayCurrencyCode case final $value?)
    'displayCurrencyCode':
        TransactionCurrencyTotalOutput$Response._write_displayCurrencyCode(
          $value,
        ),
  if (instance.displayEarning case final $value?)
    'displayEarning':
        TransactionCurrencyTotalOutput$Response._write_displayEarning($value),
  if (instance.displayExpense case final $value?)
    'displayExpense':
        TransactionCurrencyTotalOutput$Response._write_displayExpense($value),
  if (instance.displayNet case final $value?)
    'displayNet': TransactionCurrencyTotalOutput$Response._write_displayNet(
      $value,
    ),
  'earning': ?instance.earning,
  'expense': ?instance.expense,
  'net': ?instance.net,
  if (instance.rateDate case final $value?)
    'rateDate': TransactionCurrencyTotalOutput$Response._write_rateDate($value),
  'rateSource': ?TransactionCurrencyTotalOutput$Response._write_rateSource(
    instance.rateSource,
  ),
  if (instance.unconvertedReason case final $value?)
    'unconvertedReason':
        TransactionCurrencyTotalOutput$Response._write_unconvertedReason(
          $value,
        ),
};
