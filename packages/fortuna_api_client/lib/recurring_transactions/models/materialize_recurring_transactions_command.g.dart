// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommand
_$MaterializeRecurringTransactionsCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['ownerId']);
  return MaterializeRecurringTransactionsCommand(
    ownerId: !json.containsKey('ownerId')
        ? null
        : MaterializeRecurringTransactionsCommand._read_ownerId(
            json['ownerId'],
          ),
  );
}

Map<String, dynamic> _$MaterializeRecurringTransactionsCommandToJson(
  MaterializeRecurringTransactionsCommand instance,
) => <String, dynamic>{
  if (instance.ownerId case final $value?)
    'ownerId': MaterializeRecurringTransactionsCommand._write_ownerId($value),
};
