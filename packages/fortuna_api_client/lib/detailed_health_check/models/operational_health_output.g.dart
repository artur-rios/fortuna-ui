// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_health_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationalHealthOutput _$OperationalHealthOutputFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(json, allowedKeys: const ['services', 'status']);
  return OperationalHealthOutput(
    services: !json.containsKey('services')
        ? null
        : OperationalHealthOutput._read_services(json['services']),
    status: !json.containsKey('status')
        ? null
        : OperationalHealthOutput._read_status(json['status']),
  );
}

Map<String, dynamic> _$OperationalHealthOutputToJson(
  OperationalHealthOutput instance,
) => <String, dynamic>{
  if (instance.services case final $value?)
    'services': OperationalHealthOutput._write_services($value),
  if (instance.status case final $value?)
    'status': OperationalHealthOutput._write_status($value),
};
