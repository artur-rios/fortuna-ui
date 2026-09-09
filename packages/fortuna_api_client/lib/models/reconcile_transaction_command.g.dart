// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reconcile_transaction_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReconcileTransactionCommand _$ReconcileTransactionCommandFromJson(
  Map<String, dynamic> json,
) => ReconcileTransactionCommand(
  importJobId: json['importJobId'] as String?,
  importedRecordId: (json['importedRecordId'] as num?)?.toInt(),
  unreconcile: json['unreconcile'] as bool?,
);

Map<String, dynamic> _$ReconcileTransactionCommandToJson(
  ReconcileTransactionCommand instance,
) => <String, dynamic>{
  'importJobId': instance.importJobId,
  'importedRecordId': instance.importedRecordId,
  'unreconcile': instance.unreconcile,
};
