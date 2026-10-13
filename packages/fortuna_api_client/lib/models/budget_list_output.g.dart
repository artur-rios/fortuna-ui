// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetListOutput _$BudgetListOutputFromJson(Map<String, dynamic> json) =>
    BudgetListOutput(
      budgets: (json['budgets'] as List<dynamic>?)
          ?.map((e) => BudgetOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      totalItems: (json['totalItems'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BudgetListOutputToJson(BudgetListOutput instance) =>
    <String, dynamic>{
      'budgets': instance.budgets,
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
    };
