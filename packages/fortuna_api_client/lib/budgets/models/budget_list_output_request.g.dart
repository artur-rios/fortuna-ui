// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetListOutput$Request _$BudgetListOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['budgets', 'pageNumber', 'pageSize', 'totalItems'],
    disallowNullValues: const ['pageNumber', 'pageSize', 'totalItems'],
  );
  return BudgetListOutput$Request(
    budgets: !json.containsKey('budgets')
        ? null
        : BudgetListOutput$Request._read_budgets(json['budgets']),
    pageNumber: BudgetListOutput$Request._read_pageNumber(json['pageNumber']),
    pageSize: BudgetListOutput$Request._read_pageSize(json['pageSize']),
    totalItems: BudgetListOutput$Request._read_totalItems(json['totalItems']),
  );
}

Map<String, dynamic> _$BudgetListOutput$RequestToJson(
  BudgetListOutput$Request instance,
) => <String, dynamic>{
  if (instance.budgets case final $value?)
    'budgets': BudgetListOutput$Request._write_budgets($value),
  'pageNumber': ?BudgetListOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?BudgetListOutput$Request._write_pageSize(instance.pageSize),
  'totalItems': ?BudgetListOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
