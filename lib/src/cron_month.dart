import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:cron_form_field/src/util.dart';
import 'package:cron_form_field/src/cron_entity.dart';
import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_month_type.dart';

class CronMonth extends CronEntity implements CronPart {
  late CronMonthType type;
  late int everyMonth;
  late int? everyStartMonth;
  late List<int> specificMonths;
  late int betweenStartMonth;
  late int betweenEndMonth;
  bool useAlternativeValue = false;

  CronMonth(String originalValue) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory CronMonth.fromString(String monthExpression) {
    return CronMonth(monthExpression);
  }

  @override
  void setDefaults() {
    everyMonth = 1;
    everyStartMonth = null;
    specificMonths = [1]; // (0-11), 1-12, JAN-DEC
    betweenStartMonth = 0;
    betweenEndMonth = 0;
  }

  @override
  void reset() {
    type = CronMonthType.EVERY;
    setDefaults();
  }

  void setEveryMonth() {
    type = CronMonthType.EVERY;
  }

  void setEveryMonthStartAt(int month, int? startMonth) {
    type = CronMonthType.EVERY_START_AT;
    everyMonth = month;
    everyStartMonth = startMonth;
  }

  void setSpecificMonths(List<int> months) {
    type = CronMonthType.SPECIFIC;
    specificMonths = months;
  }

  void setBetweenMonths(int startMonth, int endMonth) {
    type = CronMonthType.BETWEEN;
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
      case CronMonthType.EVERY:
        break;
      case CronMonthType.EVERY_START_AT:
        var parts = value.split('/');
        everyStartMonth = parts[0] == '*' ? null : int.parse(parts[0]);
        everyMonth = int.parse(parts[1]);
        break;
      case CronMonthType.SPECIFIC:
        specificMonths = value
            .split(',')
            .map((v) => parseAlternativeValue(v, getMonthMap()))
            .toList();
        break;
      case CronMonthType.BETWEEN:
        var parts = value.split('-');
        betweenStartMonth = parseAlternativeValue(parts[0], getMonthMap());
        betweenEndMonth = parseAlternativeValue(parts[1], getMonthMap());
        break;
    }
  }

  CronMonthType _getType(String value) {
    if (value.contains('/')) {
      return CronMonthType.EVERY_START_AT;
    } else if (value.contains('*')) {
      return CronMonthType.EVERY;
    } else if (value.contains('-')) {
      return CronMonthType.BETWEEN;
    }

    return CronMonthType.SPECIFIC;
  }

  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.AUTO);
  }

  String toFormatString(CronExpressionOutputFormat outputFormat) {
    switch (type) {
      case CronMonthType.EVERY:
        return '*';
      case CronMonthType.EVERY_START_AT:
        return '${everyStartMonth ?? '*'}/$everyMonth';
      case CronMonthType.SPECIFIC:
        return (specificMonths.isEmpty ? [0] : specificMonths)
            .map((v) => convertAlternativeValue(
                  outputFormat.isAlternative(useAlternativeValue),
                  v,
                  getMonthMap(),
                ))
            .toList()
            .join(',');
      case CronMonthType.BETWEEN:
        return '${convertAlternativeValue(outputFormat.isAlternative(useAlternativeValue), betweenStartMonth, getMonthMap())}-${convertAlternativeValue(useAlternativeValue, betweenEndMonth, getMonthMap())}';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronMonthType.EVERY:
        return '';
      case CronMonthType.EVERY_START_AT:
        var startMonth = everyStartMonth ?? 0;
        return startMonth > 0
            ? 'every $everyMonth months starting at $startMonth'
            : 'every $everyMonth months';
      case CronMonthType.SPECIFIC:
        var months = (specificMonths.isEmpty ? [0] : specificMonths)
            .map((v) => convertAlternativeValue(true, v, getMonthMap()))
            .toList();
        return months.length == 1
            ? 'at month ${months[0]}'
            : 'at months ${months.getRange(0, months.length - 2).join(', ')} and ${months.last}';
      case CronMonthType.BETWEEN:
        return 'every month between ${convertAlternativeValue(true, betweenStartMonth, getMonthMap())} and ${convertAlternativeValue(true, betweenEndMonth, getMonthMap())}';
    }
  }

  @override
  bool validate(String part) {
    return true;
  }

  void handleAlternativeValue(String value) {
    useAlternativeValue = isAlternativeValue(value, getMonthMap());
  }

  Map<int, String> getMonthMap() {
    return _getMonthMap(1);
  }

  Map<int, String> _getMonthMap(int startIndex) {
    final List<String> monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OKT', 'NOV', 'DEC'];

    return getMapFromIndex(monthNames, startIndex);
  }
}
