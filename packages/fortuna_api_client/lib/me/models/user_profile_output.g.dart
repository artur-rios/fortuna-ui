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
    displayCurrency: json['displayCurrency'] as String?,
    displayCurrencyRequiresConfirmation:
        json['displayCurrencyRequiresConfirmation'] as bool?,
    displayName: json['displayName'] as String?,
    id: json['id'] as String?,
    updatedAt: UserProfileOutput._read_updatedAt(json['updatedAt']),
  );
}

Map<String, dynamic> _$UserProfileOutputToJson(UserProfileOutput instance) =>
    <String, dynamic>{
      'createdAt': ?UserProfileOutput._write_createdAt(instance.createdAt),
      'displayCurrency': ?instance.displayCurrency,
      'displayCurrencyRequiresConfirmation':
          ?instance.displayCurrencyRequiresConfirmation,
      'displayName': ?instance.displayName,
      'id': ?instance.id,
      'updatedAt': ?UserProfileOutput._write_updatedAt(instance.updatedAt),
    };
