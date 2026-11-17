// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_detail_output_data_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionDetailOutputDataOutput$Response
_$BudgetConsumptionDetailOutputDataOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'success', 'timestamp'],
    disallowNullValues: const ['success', 'timestamp'],
  );
  return BudgetConsumptionDetailOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : BudgetConsumptionDetailOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    messages: (json['messages'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    success: json['success'] as bool?,
    timestamp: BudgetConsumptionDetailOutputDataOutput$Response._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetConsumptionDetailOutputDataOutput$ResponseToJson(
  BudgetConsumptionDetailOutputDataOutput$Response instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'success': ?instance.success,
  'timestamp':
      ?BudgetConsumptionDetailOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
