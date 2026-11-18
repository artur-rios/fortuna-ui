// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemDetails _$ProblemDetailsFromJson(Map<String, dynamic> json) =>
    ProblemDetails(
      detail: json['detail'] as String?,
      instance: json['instance'] as String?,
      status: ProblemDetails._read_status(json['status']),
      title: json['title'] as String?,
      type: json['type'] as String?,
      additionalProperties:
          ProblemDetails._extras(json, 'additionalProperties') == null
          ? const {}
          : ProblemDetails._readExtras(
              ProblemDetails._extras(json, 'additionalProperties'),
            ),
    );

Map<String, dynamic> _$ProblemDetailsToJson(ProblemDetails instance) =>
    <String, dynamic>{
      'detail': ?instance.detail,
      'instance': ?instance.instance,
      'status': ?ProblemDetails._write_status(instance.status),
      'title': ?instance.title,
      'type': ?instance.type,
    };
