// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_lifecycle_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryLifecycleCommandOutput _$CategoryLifecycleCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['id', 'liveTransactionCount'],
    disallowNullValues: const ['id', 'liveTransactionCount'],
  );
  return CategoryLifecycleCommandOutput(
    id: json['id'] as String?,
    liveTransactionCount:
        CategoryLifecycleCommandOutput._read_liveTransactionCount(
          json['liveTransactionCount'],
        ),
  );
}

Map<String, dynamic> _$CategoryLifecycleCommandOutputToJson(
  CategoryLifecycleCommandOutput instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'liveTransactionCount':
      ?CategoryLifecycleCommandOutput._write_liveTransactionCount(
        instance.liveTransactionCount,
      ),
};
