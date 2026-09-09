// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_financial_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFinancialAccountCommandOutput
_$UpdateFinancialAccountCommandOutputFromJson(Map<String, dynamic> json) =>
    UpdateFinancialAccountCommandOutput(
      accountType: json['accountType'] == null
          ? null
          : FinancialAccountType.fromJson((json['accountType'] as num).toInt()),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      currencyCode: json['currencyCode'] as String?,
      id: json['id'] as String?,
      institution: json['institution'] as String?,
      name: json['name'] as String?,
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UpdateFinancialAccountCommandOutputToJson(
  UpdateFinancialAccountCommandOutput instance,
) => <String, dynamic>{
  'accountType': instance.accountType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'institution': instance.institution,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
