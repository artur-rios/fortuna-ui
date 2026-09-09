// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_financial_account_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFinancialAccountCommandOutput
_$CreateFinancialAccountCommandOutputFromJson(Map<String, dynamic> json) =>
    CreateFinancialAccountCommandOutput(
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

Map<String, dynamic> _$CreateFinancialAccountCommandOutputToJson(
  CreateFinancialAccountCommandOutput instance,
) => <String, dynamic>{
  'accountType': _$FinancialAccountTypeEnumMap[instance.accountType],
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'institution': instance.institution,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$FinancialAccountTypeEnumMap = {
  FinancialAccountType.value1: 1,
  FinancialAccountType.value2: 2,
  FinancialAccountType.value3: 3,
  FinancialAccountType.value4: 4,
  FinancialAccountType.$unknown: r'$unknown',
};
