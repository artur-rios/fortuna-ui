// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_consumption_detail_output_data_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetConsumptionDetailOutputDataOutput$Request
_$BudgetConsumptionDetailOutputDataOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['data', 'errors', 'messages', 'timestamp'],
    disallowNullValues: const ['timestamp'],
  );
  return BudgetConsumptionDetailOutputDataOutput$Request(
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
    timestamp: BudgetConsumptionDetailOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetConsumptionDetailOutputDataOutput$RequestToJson(
  BudgetConsumptionDetailOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  'errors': ?instance.errors,
  'messages': ?instance.messages,
  'timestamp':
      ?BudgetConsumptionDetailOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
