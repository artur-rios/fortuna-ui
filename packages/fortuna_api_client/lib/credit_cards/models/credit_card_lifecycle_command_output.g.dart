// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_card_lifecycle_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCardLifecycleCommandOutput _$CreditCardLifecycleCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['currencyCode', 'id', 'outstandingAmount'],
    disallowNullValues: const ['id', 'outstandingAmount'],
  );
  return CreditCardLifecycleCommandOutput(
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : CreditCardLifecycleCommandOutput._read_currencyCode(
            json['currencyCode'],
          ),
    id: json['id'] as String?,
    outstandingAmount: json['outstandingAmount'] as String?,
  );
}

Map<String, dynamic> _$CreditCardLifecycleCommandOutputToJson(
  CreditCardLifecycleCommandOutput instance,
) => <String, dynamic>{
  if (instance.currencyCode case final $value?)
    'currencyCode': CreditCardLifecycleCommandOutput._write_currencyCode(
      $value,
    ),
  'id': ?instance.id,
  'outstandingAmount': ?instance.outstandingAmount,
};
