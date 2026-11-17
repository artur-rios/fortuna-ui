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
    services: (json['services'] as List<dynamic>?)
        ?.map(
          (e) => OperationalHealthServiceOutput.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList(),
    status: json['status'] as String?,
  );
}

Map<String, dynamic> _$OperationalHealthOutputToJson(
  OperationalHealthOutput instance,
) => <String, dynamic>{
  'services': ?instance.services?.map((e) => e.toJson()).toList(),
  'status': ?instance.status,
};
