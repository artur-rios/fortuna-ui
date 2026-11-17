// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'erase_user_command_output_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EraseUserCommandOutput$Response _$EraseUserCommandOutput$ResponseFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const ['erased', 'irreversible', 'revokedConnections'],
    disallowNullValues: const ['irreversible', 'revokedConnections'],
  );
  return EraseUserCommandOutput$Response(
    erased: EraseUserCommandOutput$Response._read_erased(json['erased']),
    irreversible: json['irreversible'] as bool?,
    revokedConnections:
        EraseUserCommandOutput$Response._read_revokedConnections(
          json['revokedConnections'],
        ),
  );
}

Map<String, dynamic> _$EraseUserCommandOutput$ResponseToJson(
  EraseUserCommandOutput$Response instance,
) => <String, dynamic>{
  'erased': ?EraseUserCommandOutput$Response._write_erased(instance.erased),
  'irreversible': ?instance.irreversible,
  'revokedConnections':
      ?EraseUserCommandOutput$Response._write_revokedConnections(
        instance.revokedConnections,
      ),
};
