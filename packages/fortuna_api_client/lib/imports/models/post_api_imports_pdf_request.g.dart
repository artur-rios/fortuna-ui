// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api_imports_pdf_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostApiImportsPdfRequest _$PostApiImportsPdfRequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, disallowNullValues: const ['CreditCardId', 'File']);
  return PostApiImportsPdfRequest(
    creditCardId: json['CreditCardId'] as String?,
    file: json['File'] as String?,
    additionalProperties:
        PostApiImportsPdfRequest._extras(json, 'additionalProperties') == null
        ? const {}
        : PostApiImportsPdfRequest._readExtras(
            PostApiImportsPdfRequest._extras(json, 'additionalProperties'),
          ),
  );
}

Map<String, dynamic> _$PostApiImportsPdfRequestToJson(
  PostApiImportsPdfRequest instance,
) => <String, dynamic>{
  'CreditCardId': ?instance.creditCardId,
  'File': ?instance.file,
};
