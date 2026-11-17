// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileOutput _$UserProfileOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const [
      'createdAt',
      'displayCurrency',
      'displayCurrencyRequiresConfirmation',
      'displayName',
      'id',
      'updatedAt',
    ],
    disallowNullValues: const [
      'createdAt',
      'displayCurrencyRequiresConfirmation',
      'id',
      'updatedAt',
    ],
  );
  return UserProfileOutput(
    createdAt: UserProfileOutput._read_createdAt(json['createdAt']),
    displayCurrency: !json.containsKey('displayCurrency')
        ? null
        : UserProfileOutput._read_displayCurrency(json['displayCurrency']),
    displayCurrencyRequiresConfirmation:
        json['displayCurrencyRequiresConfirmation'] as bool?,
    displayName: !json.containsKey('displayName')
        ? null
        : UserProfileOutput._read_displayName(json['displayName']),
    id: json['id'] as String?,
    updatedAt: UserProfileOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$UserProfileOutputToJson(UserProfileOutput instance) =>
    <String, dynamic>{
      'createdAt': ?UserProfileOutput._write_createdAt(instance.createdAt),
      if (instance.displayCurrency case final $value?)
        'displayCurrency': UserProfileOutput._write_displayCurrency($value),
      'displayCurrencyRequiresConfirmation':
          ?instance.displayCurrencyRequiresConfirmation,
      if (instance.displayName case final $value?)
        'displayName': UserProfileOutput._write_displayName($value),
      'id': ?instance.id,
      'updatedAt': ?UserProfileOutput._write_updatedAt(instance.updatedAt),
    };
