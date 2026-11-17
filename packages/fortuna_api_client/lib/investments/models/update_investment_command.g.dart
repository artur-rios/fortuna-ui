// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_investment_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateInvestmentCommand _$UpdateInvestmentCommandFromJson(
  Map<String, dynamic> json,
) {
  $checkKeys(
    json,
    allowedKeys: const [
      'currencyCode',
      'institution',
      'instrument',
      'investmentType',
    ],
    disallowNullValues: const ['investmentType'],
  );
  return UpdateInvestmentCommand(
    currencyCode: json['currencyCode'] as String?,
    institution: json['institution'] as String?,
    instrument: json['instrument'] as String?,
    investmentType: UpdateInvestmentCommand._read_investmentType(
      json['investmentType'],
    ),
  );
}

Map<String, dynamic> _$UpdateInvestmentCommandToJson(
  UpdateInvestmentCommand instance,
) => <String, dynamic>{
  'currencyCode': ?instance.currencyCode,
  'institution': ?instance.institution,
  'instrument': ?instance.instrument,
  'investmentType': ?UpdateInvestmentCommand._write_investmentType(
    instance.investmentType,
  ),
};
