// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_lifecycle_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvestmentLifecycleCommandOutput _$InvestmentLifecycleCommandOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['id'], disallowNullValues: const ['id']);
  return InvestmentLifecycleCommandOutput(id: json['id'] as String?);
}

Map<String, dynamic> _$InvestmentLifecycleCommandOutputToJson(
  InvestmentLifecycleCommandOutput instance,
) => <String, dynamic>{'id': ?instance.id};
