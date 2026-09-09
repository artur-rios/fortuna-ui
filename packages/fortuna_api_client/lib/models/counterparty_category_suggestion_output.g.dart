// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_category_suggestion_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyCategorySuggestionOutput
_$CounterpartyCategorySuggestionOutputFromJson(Map<String, dynamic> json) =>
    CounterpartyCategorySuggestionOutput(
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      counterpartyId: json['counterpartyId'] as String?,
      hasSuggestion: json['hasSuggestion'] as bool?,
    );

Map<String, dynamic> _$CounterpartyCategorySuggestionOutputToJson(
  CounterpartyCategorySuggestionOutput instance,
) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'counterpartyId': instance.counterpartyId,
  'hasSuggestion': instance.hasSuggestion,
};
