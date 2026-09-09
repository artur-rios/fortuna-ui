// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinancialAccountOutput _$FinancialAccountOutputFromJson(
  Map<String, dynamic> json,
) => FinancialAccountOutput(
  accountType: json['accountType'] == null
      ? null
      : FinancialAccountType.fromJson((json['accountType'] as num).toInt()),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  currencyCode: json['currencyCode'] as String?,
  id: json['id'] as String?,
  institution: json['institution'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  name: json['name'] as String?,
  openingBalance: (json['openingBalance'] as num?)?.toDouble(),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$FinancialAccountOutputToJson(
  FinancialAccountOutput instance,
) => <String, dynamic>{
  'accountType': instance.accountType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'currencyCode': instance.currencyCode,
  'id': instance.id,
  'institution': instance.institution,
  'isDeleted': instance.isDeleted,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
