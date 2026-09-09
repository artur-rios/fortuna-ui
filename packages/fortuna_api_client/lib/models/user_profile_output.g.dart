// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileOutput _$UserProfileOutputFromJson(Map<String, dynamic> json) =>
    UserProfileOutput(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      displayCurrency: json['displayCurrency'] as String?,
      displayCurrencyRequiresConfirmation:
          json['displayCurrencyRequiresConfirmation'] as bool?,
      displayName: json['displayName'] as String?,
      id: json['id'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserProfileOutputToJson(UserProfileOutput instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'displayCurrency': instance.displayCurrency,
      'displayCurrencyRequiresConfirmation':
          instance.displayCurrencyRequiresConfirmation,
      'displayName': instance.displayName,
      'id': instance.id,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
