import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:cron_form_field/src/util.dart';

import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_month_type.dart';
import 'package:cron_form_field/src/enums/cron_expression_type.dart';

class CronMonth implements CronPart {
  late CronMonthType type;
  late int everyMonth;
  late int? everyStartMonth;
  late List<int> specificMonths;
  late int betweenStartMonth;
  late int betweenEndMonth;
  bool useAlternativeValue = false;
  CronExpressionType expressionType;

  CronMonth(String originalValue, this.expressionType) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 1-12, JAN-DEC, (0-11)
    everyMonth = 1;
    everyStartMonth = null;
    specificMonths = [startIndex];
    betweenStartMonth = startIndex;
    betweenEndMonth = startIndex;
  }

  @override
  void reset() {
    type = CronMonthType.every;
    setDefaults();
  }

  void setEveryMonth() {
    type = CronMonthType.every;
  }

  void setEveryMonthStartAt(int month, [int? startMonth]) {
    type = CronMonthType.everyStartAt;
    everyMonth = month;
    everyStartMonth = startMonth;
  }

  void setSpecificMonths(List<int> months) {
    type = CronMonthType.specific;
    specificMonths = months;
  }

  void setBetweenMonths(int startMonth, int endMonth) {
    type = CronMonthType.between;
    betweenStartMonth = startMonth;
    betweenEndMonth = endMonth;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid month part of expression!');
    }
    handleAlternativeValue(value);
    type = _getType(value);
    switch (type) {
      case CronMonthType.every:
        break;
      case CronMonthType.everyStartAt:
        var parts = value.split('/');
        everyStartMonth = parts[0] == '*' ? null : int.parse(parts[0]);
        everyMonth = int.parse(parts[1]);
        break;
      case CronMonthType.specific:
        specificMonths = value
            .split(',')
            .map((v) => parseAlternativeValue(v, getMonthMap()))
            .toList();
        break;
      case CronMonthType.between:
        var parts = value.split('-');
        betweenStartMonth = parseAlternativeValue(parts[0], getMonthMap());
        betweenEndMonth = parseAlternativeValue(parts[1], getMonthMap());
        break;
    }
  }

  CronMonthType _getType(String value) {
    if (value.contains('/')) {
      return CronMonthType.everyStartAt;
    } else if (value.contains('*')) {
      return CronMonthType.every;
    } else if (value.contains('-')) {
      return CronMonthType.between;
    }

    return CronMonthType.specific;
  }

  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.auto);
  }

  String toFormatString(CronExpressionOutputFormat outputFormat) {
    switch (type) {
      case CronMonthType.every:
        return '*';
      case CronMonthType.everyStartAt:
        return '${everyStartMonth ?? '*'}/$everyMonth';
      case CronMonthType.specific:
        return (specificMonths.isEmpty ? [startIndex] : specificMonths)
            .map((v) => convertAlternativeValue(
                  outputFormat.isAlternative(useAlternativeValue),
                  v,
                  getMonthMap(),
                ))
            .toList()
            .join(',');
      case CronMonthType.between:
        return '${convertAlternativeValue(outputFormat.isAlternative(useAlternativeValue), betweenStartMonth, getMonthMap())}-${convertAlternativeValue(useAlternativeValue, betweenEndMonth, getMonthMap())}';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronMonthType.every:
        return '';
      case CronMonthType.everyStartAt:
        var startMonth = everyStartMonth ?? 0;
        return startMonth > 0
            ? 'every $everyMonth months starting at $startMonth'
            : 'every $everyMonth months';
      case CronMonthType.specific:
        var months = (specificMonths.isEmpty ? [startIndex] : specificMonths)
            .map((v) => convertAlternativeValue(true, v, getMonthMap()))
            .toList();
        return months.length == 1
            ? 'at month ${months[0]}'
            : 'at months ${months.getRange(0, months.length - 1).join(', ')} and ${months.last}';
      case CronMonthType.between:
        return 'every month between ${convertAlternativeValue(true, betweenStartMonth, getMonthMap())} and ${convertAlternativeValue(true, betweenEndMonth, getMonthMap())}';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(
            r'^(\*|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9A-Z]{1,3}(-[0-9A-Z]{1,3}|)(,[0-9A-Z]{1,3})*)$',
            caseSensitive: false)
        .hasMatch(part);
  }

  void handleAlternativeValue(String value) {
    useAlternativeValue = isAlternativeValue(value, getMonthMap());
  }

  Map<int, String> getMonthMap() {
    final List<String> monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];

    return getMapFromIndex(monthNames, startIndex);
  }

  @override
  int get startIndex {
    return expressionType == CronExpressionType.standard ? 1 : 0;
  }
}
