// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTreeOutput _$CategoryTreeOutputFromJson(Map<String, dynamic> json) =>
    CategoryTreeOutput(
      canSeedDefaults: json['canSeedDefaults'] as bool?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryTreeOutputToJson(CategoryTreeOutput instance) =>
    <String, dynamic>{
      'canSeedDefaults': instance.canSeedDefaults,
      'categories': instance.categories,
    };
