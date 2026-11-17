// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merge_counterparties_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MergeCounterpartiesCommand _$MergeCounterpartiesCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['targetId'],
    disallowNullValues: const ['targetId'],
  );
  return MergeCounterpartiesCommand(targetId: json['targetId'] as String?);
}

Map<String, dynamic> _$MergeCounterpartiesCommandToJson(
  MergeCounterpartiesCommand instance,
) => <String, dynamic>{'targetId': ?instance.targetId};
