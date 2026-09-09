// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_investment_valuation_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordInvestmentValuationCommandOutput
_$RecordInvestmentValuationCommandOutputFromJson(Map<String, dynamic> json) =>
    RecordInvestmentValuationCommandOutput(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      id: json['id'] as String?,
      investmentId: json['investmentId'] as String?,
      isIndependentlyValued: json['isIndependentlyValued'] as bool?,
      latestValuationDate: json['latestValuationDate'] == null
          ? null
          : DateTime.parse(json['latestValuationDate'] as String),
      latestValuationValue: (json['latestValuationValue'] as num?)?.toDouble(),
      position: (json['position'] as num?)?.toDouble(),
      replacedExisting: json['replacedExisting'] as bool?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      value: (json['value'] as num?)?.toDouble(),
      valuedOn: json['valuedOn'] == null
          ? null
          : DateTime.parse(json['valuedOn'] as String),
    );

Map<String, dynamic> _$RecordInvestmentValuationCommandOutputToJson(
  RecordInvestmentValuationCommandOutput instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'investmentId': instance.investmentId,
  'isIndependentlyValued': instance.isIndependentlyValued,
  'latestValuationDate': instance.latestValuationDate?.toIso8601String(),
  'latestValuationValue': instance.latestValuationValue,
  'position': instance.position,
  'replacedExisting': instance.replacedExisting,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'value': instance.value,
  'valuedOn': instance.valuedOn?.toIso8601String(),
};
