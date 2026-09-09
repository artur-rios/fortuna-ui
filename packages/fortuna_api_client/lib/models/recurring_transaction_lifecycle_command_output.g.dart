// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_lifecycle_command_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionLifecycleCommandOutput
_$RecurringTransactionLifecycleCommandOutputFromJson(
  Map<String, dynamic> json,
) => RecurringTransactionLifecycleCommandOutput(
  id: json['id'] as String?,
  materializedOccurrencesChanged:
      json['materializedOccurrencesChanged'] as bool?,
);

Map<String, dynamic> _$RecurringTransactionLifecycleCommandOutputToJson(
  RecurringTransactionLifecycleCommandOutput instance,
) => <String, dynamic>{
  'id': instance.id,
  'materializedOccurrencesChanged': instance.materializedOccurrencesChanged,
};
