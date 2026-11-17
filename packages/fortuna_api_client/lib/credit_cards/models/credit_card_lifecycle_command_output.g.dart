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
    currencyCode: json['currencyCode'] as String?,
    id: json['id'] as String?,
    outstandingAmount: json['outstandingAmount'] as String?,
  );
}

Map<String, dynamic> _$CreditCardLifecycleCommandOutputToJson(
  CreditCardLifecycleCommandOutput instance,
) => <String, dynamic>{
  'currencyCode': ?instance.currencyCode,
  'id': ?instance.id,
  'outstandingAmount': ?instance.outstandingAmount,
};
