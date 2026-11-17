// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_list_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetListOutput$Response _$BudgetListOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'budgets',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
  );
  return BudgetListOutput$Response(
    budgets: (json['budgets'] as List<dynamic>?)
        ?.map((e) => BudgetOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    pageNumber: BudgetListOutput$Response._read_pageNumber(json['pageNumber']),
    pageSize: BudgetListOutput$Response._read_pageSize(json['pageSize']),
    totalItems: BudgetListOutput$Response._read_totalItems(json['totalItems']),
    totalPages: BudgetListOutput$Response._read_totalPages(json['totalPages']),
  );
}

Map<String, dynamic> _$BudgetListOutput$ResponseToJson(
  BudgetListOutput$Response instance,
) => <String, dynamic>{
  'budgets': ?instance.budgets?.map((e) => e.toJson()).toList(),
  'pageNumber': ?BudgetListOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?BudgetListOutput$Response._write_pageSize(instance.pageSize),
  'totalItems': ?BudgetListOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?BudgetListOutput$Response._write_totalPages(
    instance.totalPages,
  ),
};
