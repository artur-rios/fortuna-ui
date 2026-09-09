// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommand _$RecordInvestmentValuationCommandFromJson(
  Map<String, dynamic> json,
) => RecordInvestmentValuationCommand(
  id: json['id'] as String?,
  value: (json['value'] as num?)?.toDouble(),
  valuedOn: json['valuedOn'] == null
      ? null
      : DateTime.parse(json['valuedOn'] as String),
);

Map<String, dynamic> _$RecordInvestmentValuationCommandToJson(
  RecordInvestmentValuationCommand instance,
) => <String, dynamic>{
  'id': instance.id,
  'value': instance.value,
  'valuedOn': instance.valuedOn?.toIso8601String(),
};
