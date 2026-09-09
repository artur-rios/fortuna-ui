// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_flow_figure_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFlowFigureOutput _$CashFlowFigureOutputFromJson(
  Map<String, dynamic> json,
) => CashFlowFigureOutput(
  amount: (json['amount'] as num?)?.toDouble(),
  kind: json['kind'] == null
      ? null
      : CashFlowFigureKind.fromJson((json['kind'] as num).toInt()),
);

Map<String, dynamic> _$CashFlowFigureOutputToJson(
  CashFlowFigureOutput instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'kind': _$CashFlowFigureKindEnumMap[instance.kind],
};

const _$CashFlowFigureKindEnumMap = {
  CashFlowFigureKind.value1: 1,
  CashFlowFigureKind.value2: 2,
  CashFlowFigureKind.value3: 3,
  CashFlowFigureKind.value4: 4,
  CashFlowFigureKind.$unknown: r'$unknown',
};
