// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterparty_list_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterpartyListOutput$Response _$CounterpartyListOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'counterparties',
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
    disallowNullValues: const [
      'pageNumber',
      'pageSize',
      'totalItems',
      'totalPages',
    ],
  );
  return CounterpartyListOutput$Response(
    counterparties: !json.containsKey('counterparties')
        ? null
        : CounterpartyListOutput$Response._read_counterparties(
            json['counterparties'],
          ),
    pageNumber: CounterpartyListOutput$Response._read_pageNumber(
      json['pageNumber'],
    ),
    pageSize: CounterpartyListOutput$Response._read_pageSize(json['pageSize']),
    totalItems: CounterpartyListOutput$Response._read_totalItems(
      json['totalItems'],
    ),
    totalPages: CounterpartyListOutput$Response._read_totalPages(
      json['totalPages'],
    ),
  );
}

Map<String, dynamic> _$CounterpartyListOutput$ResponseToJson(
  CounterpartyListOutput$Response instance,
) => <String, dynamic>{
  if (instance.counterparties case final $value?)
    'counterparties': CounterpartyListOutput$Response._write_counterparties(
      $value,
    ),
  'pageNumber': ?CounterpartyListOutput$Response._write_pageNumber(
    instance.pageNumber,
  ),
  'pageSize': ?CounterpartyListOutput$Response._write_pageSize(
    instance.pageSize,
  ),
  'totalItems': ?CounterpartyListOutput$Response._write_totalItems(
    instance.totalItems,
  ),
  'totalPages': ?CounterpartyListOutput$Response._write_totalPages(
    instance.totalPages,
  ),
};
