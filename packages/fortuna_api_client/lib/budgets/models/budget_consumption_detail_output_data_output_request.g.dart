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
    disallowNullValues: const ['data', 'timestamp'],
  );
  return BudgetConsumptionDetailOutputDataOutput$Request(
    data: json['data'] == null
        ? null
        : BudgetConsumptionDetailOutput.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
    errors: !json.containsKey('errors')
        ? null
        : BudgetConsumptionDetailOutputDataOutput$Request._read_errors(
            json['errors'],
          ),
    messages: !json.containsKey('messages')
        ? null
        : BudgetConsumptionDetailOutputDataOutput$Request._read_messages(
            json['messages'],
          ),
    timestamp: BudgetConsumptionDetailOutputDataOutput$Request._read_timestamp(
      json['timestamp'],
    ),
  );
}

Map<String, dynamic> _$BudgetConsumptionDetailOutputDataOutput$RequestToJson(
  BudgetConsumptionDetailOutputDataOutput$Request instance,
) => <String, dynamic>{
  'data': ?instance.data?.toJson(),
  if (instance.errors case final $value?)
    'errors': BudgetConsumptionDetailOutputDataOutput$Request._write_errors(
      $value,
    ),
  if (instance.messages case final $value?)
    'messages': BudgetConsumptionDetailOutputDataOutput$Request._write_messages(
      $value,
    ),
  'timestamp':
      ?BudgetConsumptionDetailOutputDataOutput$Request._write_timestamp(
        instance.timestamp,
      ),
};
