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
);

Map<String, dynamic> _$CounterpartyListOutputToJson(
  CounterpartyListOutput instance,
) => <String, dynamic>{'counterparties': instance.counterparties};
