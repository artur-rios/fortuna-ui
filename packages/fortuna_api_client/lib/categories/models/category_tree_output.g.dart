// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTreeOutput _$CategoryTreeOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['canSeedDefaults', 'categories'],
    disallowNullValues: const ['canSeedDefaults'],
  );
  return CategoryTreeOutput(
    canSeedDefaults: json['canSeedDefaults'] as bool?,
    categories: !json.containsKey('categories')
        ? null
        : CategoryTreeOutput._read_categories(json['categories']),
  );
}

Map<String, dynamic> _$CategoryTreeOutputToJson(CategoryTreeOutput instance) =>
    <String, dynamic>{
      'canSeedDefaults': ?instance.canSeedDefaults,
      if (instance.categories case final $value?)
        'categories': CategoryTreeOutput._write_categories($value),
    };
