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
    currencyCode: !json.containsKey('currencyCode')
        ? null
        : UpdateInvestmentCommand._read_currencyCode(json['currencyCode']),
    institution: !json.containsKey('institution')
        ? null
        : UpdateInvestmentCommand._read_institution(json['institution']),
    instrument: !json.containsKey('instrument')
        ? null
        : UpdateInvestmentCommand._read_instrument(json['instrument']),
    investmentType: UpdateInvestmentCommand._read_investmentType(
      json['investmentType'],
    ),
  );
}

Map<String, dynamic> _$UpdateInvestmentCommandToJson(
  UpdateInvestmentCommand instance,
) => <String, dynamic>{
  if (instance.currencyCode case final $value?)
    'currencyCode': UpdateInvestmentCommand._write_currencyCode($value),
  if (instance.institution case final $value?)
    'institution': UpdateInvestmentCommand._write_institution($value),
  if (instance.instrument case final $value?)
    'instrument': UpdateInvestmentCommand._write_instrument($value),
  'investmentType': ?UpdateInvestmentCommand._write_investmentType(
    instance.investmentType,
  ),
};
