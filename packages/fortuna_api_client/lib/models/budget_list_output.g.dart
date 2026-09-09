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
    );

Map<String, dynamic> _$BudgetListOutputToJson(BudgetListOutput instance) =>
    <String, dynamic>{'budgets': instance.budgets};
