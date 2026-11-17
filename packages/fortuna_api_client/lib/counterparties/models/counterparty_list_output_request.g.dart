// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutput$Request _$CounterpartyListOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'counterparties',
      'pageNumber',
      'pageSize',
      'totalItems',
    ],
    disallowNullValues: const ['pageNumber', 'pageSize', 'totalItems'],
  );
  return CounterpartyListOutput$Request(
    counterparties: (json['counterparties'] as List<dynamic>?)
        ?.map((e) => CounterpartyOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
    pageNumber: CounterpartyListOutput$Request._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: CounterpartyListOutput$Request._read_pageSize(json['pageSize']),
    totalItems: CounterpartyListOutput$Request._read_totalItems(
      json['totalItems'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutput$RequestToJson(
  CounterpartyListOutput$Request instance,
) => <String, dynamic>{
  'counterparties': ?instance.counterparties?.map((e) => e.toJson()).toList(),
  'pageNumber': ?CounterpartyListOutput$Request._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?CounterpartyListOutput$Request._write_pageSize(
    instance.pageSize,
  ),
  'totalItems': ?CounterpartyListOutput$Request._write_totalItems(
    instance.totalItems,
  ),
};
