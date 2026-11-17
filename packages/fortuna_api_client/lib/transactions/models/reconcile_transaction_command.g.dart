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
    importJobId: json['importJobId'] as String?,
    importedRecordId: ReconcileTransactionCommand._read_importedRecordId(
      json['importedRecordId'],
    ),
    unreconcile: json['unreconcile'] as bool?,
  );
}

Map<String, dynamic> _$ReconcileTransactionCommandToJson(
  ReconcileTransactionCommand instance,
) => <String, dynamic>{
  'importJobId': ?instance.importJobId,
  'importedRecordId': ?ReconcileTransactionCommand._write_importedRecordId(
    instance.importedRecordId,
  ),
  'unreconcile': ?instance.unreconcile,
};
