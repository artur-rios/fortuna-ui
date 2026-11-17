// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_figure_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowFigureOutput _$CashFlowFigureOutputFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    allowedKeys: const ['amount', 'kind'],
    disallowNullValues: const ['amount', 'kind'],
  );
  return CashFlowFigureOutput(
    amount: json['amount'] as String?,
    kind: CashFlowFigureOutput._read_kind(json['kind']),
  );
}

Map<String, dynamic> _$CashFlowFigureOutputToJson(
  CashFlowFigureOutput instance,
) => <String, dynamic>{
  'amount': ?instance.amount,
  'kind': ?CashFlowFigureOutput._write_kind(instance.kind),
};
