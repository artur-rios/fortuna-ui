// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command_output_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommandOutput$Request _$EraseUserCommandOutput$RequestFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['erased', 'revokedConnections'],
    disallowNullValues: const ['revokedConnections'],
  );
  return EraseUserCommandOutput$Request(
    erased: !json.containsKey('erased')
        ? null
        : EraseUserCommandOutput$Request._read_erased(json['erased']),
    revokedConnections: EraseUserCommandOutput$Request._read_revokedConnections(
      json['revokedConnections'],
    ),
  );
}

Map<String, dynamic> _$EraseUserCommandOutput$RequestToJson(
  EraseUserCommandOutput$Request instance,
) => <String, dynamic>{
  if (instance.erased case final $value?)
    'erased': EraseUserCommandOutput$Request._write_erased($value),
  'revokedConnections':
      ?EraseUserCommandOutput$Request._write_revokedConnections(
        instance.revokedConnections,
      ),
};
