// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_transactions_by_id_attachments_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiTransactionsByIdAttachmentsRequest
_$PostApiTransactionsByIdAttachmentsRequestFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['File']);
  return PostApiTransactionsByIdAttachmentsRequest(
    file: json['File'] as String?,
    additionalProperties:
        PostApiTransactionsByIdAttachmentsRequest._extras(
              json,
              'additionalProperties',
            ) ==
            null
        ? const {}
        : PostApiTransactionsByIdAttachmentsRequest._readExtras(
            PostApiTransactionsByIdAttachmentsRequest._extras(
              json,
              'additionalProperties',
            ),
          ),
  );
}

Map<String, dynamic> _$PostApiTransactionsByIdAttachmentsRequestToJson(
  PostApiTransactionsByIdAttachmentsRequest instance,
) => <String, dynamic>{'File': ?instance.file};
