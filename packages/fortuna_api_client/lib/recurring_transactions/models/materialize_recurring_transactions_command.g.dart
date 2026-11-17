// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialize_recurring_transactions_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterializeRecurringTransactionsCommand
_$MaterializeRecurringTransactionsCommandFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['ownerId']);
  return MaterializeRecurringTransactionsCommand(
    ownerId: json['ownerId'] as String?,
  );
}

Map<String, dynamic> _$MaterializeRecurringTransactionsCommandToJson(
  MaterializeRecurringTransactionsCommand instance,
) => <String, dynamic>{'ownerId': ?instance.ownerId};
