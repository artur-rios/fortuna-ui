// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommand _$ReconcileTransactionCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['importJobId', 'importedRecordId', 'unreconcile'],
    disallowNullValues: const ['unreconcile'],
  );
  return ReconcileTransactionCommand(
    importJobId: !json.containsKey('importJobId')
        ? null
        : ReconcileTransactionCommand._read_importJobId(json['importJobId']),
    importedRecordId: !json.containsKey('importedRecordId')
        ? null
        : ReconcileTransactionCommand._read_importedRecordId(
            json['importedRecordId'],
          ),
    unreconcile: json['unreconcile'] as bool?,
  );
}

Map<String, dynamic> _$ReconcileTransactionCommandToJson(
  ReconcileTransactionCommand instance,
) => <String, dynamic>{
  if (instance.importJobId case final $value?)
    'importJobId': ReconcileTransactionCommand._write_importJobId($value),
  if (instance.importedRecordId case final $value?)
    'importedRecordId': ReconcileTransactionCommand._write_importedRecordId(
      $value,
    ),
  'unreconcile': ?instance.unreconcile,
};
