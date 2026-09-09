// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchOutput _$TransactionSearchOutputFromJson(
  Map<String, dynamic> json,
) => TransactionSearchOutput(
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => TransactionOutput.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  totals: json['totals'] == null
      ? null
      : TransactionTotalsOutput.fromJson(
          json['totals'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TransactionSearchOutputToJson(
  TransactionSearchOutput instance,
) => <String, dynamic>{
  'items': instance.items,
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
  'totals': instance.totals,
};
