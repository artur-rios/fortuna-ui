// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutput _$CounterpartyListOutputFromJson(
  Map<String, dynamic> json,
) => CounterpartyListOutput(
  counterparties: (json['counterparties'] as List<dynamic>?)
      ?.map((e) => CounterpartyOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$CounterpartyListOutputToJson(
  CounterpartyListOutput instance,
) => <String, dynamic>{
  'counterparties': instance.counterparties,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
};
