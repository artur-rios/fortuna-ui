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
    disallowNullValues: const ['data', 'success', 'timestamp'],
  );
  return BudgetConsumptionDetailOutputDataOutput$Response(
    data: json['data'] == null
        ? null
        : BudgetConsumptionDetailOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : BudgetConsumptionDetailOutputDataOutput$Response._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : BudgetConsumptionDetailOutputDataOutput$Response._read_messages(
            json['messages'],
          ),
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
  if (instance.errors case final $value?)
    'errors': BudgetConsumptionDetailOutputDataOutput$Response._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages':
        BudgetConsumptionDetailOutputDataOutput$Response._write_messages(
          $value,
        ),
  'success': ?instance.success,
  'timestamp':
      ?BudgetConsumptionDetailOutputDataOutput$Response._write_timestamp(
        instance.timestamp,
      ),
};
