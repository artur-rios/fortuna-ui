// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommand _$RecordInvestmentValuationCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'value', 'valuedOn'],
    disallowNullValues: const ['id', 'value', 'valuedOn'],
  );
  return RecordInvestmentValuationCommand(
    id: json['id'] as String?,
    value: json['value'] as String?,
    valuedOn: json['valuedOn'] as String?,
  );
}

Map<String, dynamic> _$RecordInvestmentValuationCommandToJson(
  RecordInvestmentValuationCommand instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'value': ?instance.value,
  'valuedOn': ?instance.valuedOn,
};
