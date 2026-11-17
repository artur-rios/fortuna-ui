// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_category_suggestion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCategorySuggestionOutput
_$CounterpartyCategorySuggestionOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'categoryId',
      'categoryName',
      'counterpartyId',
      'hasSuggestion',
    ],
    disallowNullValues: const ['counterpartyId', 'hasSuggestion'],
  );
  return CounterpartyCategorySuggestionOutput(
    categoryId: !json.containsKey('categoryId')
        ? null
        : CounterpartyCategorySuggestionOutput._read_categoryId(
            json['categoryId'],
          ),
    categoryName: !json.containsKey('categoryName')
        ? null
        : CounterpartyCategorySuggestionOutput._read_categoryName(
            json['categoryName'],
          ),
    counterpartyId: json['counterpartyId'] as String?,
    hasSuggestion: json['hasSuggestion'] as bool?,
  );
}

Map<String, dynamic> _$CounterpartyCategorySuggestionOutputToJson(
  CounterpartyCategorySuggestionOutput instance,
) => <String, dynamic>{
  if (instance.categoryId case final $value?)
    'categoryId': CounterpartyCategorySuggestionOutput._write_categoryId(
      $value,
    ),
  if (instance.categoryName case final $value?)
    'categoryName': CounterpartyCategorySuggestionOutput._write_categoryName(
      $value,
    ),
  'counterpartyId': ?instance.counterpartyId,
  'hasSuggestion': ?instance.hasSuggestion,
};
