import 'cron_entity.dart';
import 'cron_part.dart';

enum CronMonthType { EVERY, EVERY_START_AT, SPECIFIC, BETWEEN }

class CronMonth extends CronEntity implements CronPart {
  late CronMonthType type;
  late int everyMonth;
  late int? everyStartMonth;
  late List<String> specificMonths;
  late int betweenStartMonth;
  late int betweenEndMonth;

  CronMonth(String originalValue) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory CronMonth.fromString(String monthExpression) {
    return CronMonth(monthExpression);
  }

  void setDefaults() {
    // 1-12, JAN-DEC
    everyMonth = 1;
    everyStartMonth = null;
    specificMonths = ['JAN'];
    betweenStartMonth = 0;
    betweenEndMonth = 0;
  }

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

  void setSpecificMonths(List<String> months) {
    type = CronMonthType.SPECIFIC;
    specificMonths = months;
  }

  void setBetweenMonths(int startMonth, int endMonth) {
    type = CronMonthType.BETWEEN;
    betweenStartMonth = startMonth;
    betweenEndMonth = endMonth;
  }

  void _setValue(String value) {
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
        specificMonths = value.split(',').toList();
        break;
      case CronMonthType.BETWEEN:
        var parts = value.split('-');
        betweenStartMonth = int.parse(parts[0]);
        betweenEndMonth = int.parse(parts[1]);
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

  String toString() {
    switch (type) {
      case CronMonthType.EVERY:
        return '*';
      case CronMonthType.EVERY_START_AT:
        return '${everyStartMonth ?? '*'}/$everyMonth';
      case CronMonthType.SPECIFIC:
        return specificMonths.isEmpty ? '1' : specificMonths.join(',');
      case CronMonthType.BETWEEN:
        return '$betweenStartMonth-$betweenEndMonth';
    }
  }

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
        var months = specificMonths.isEmpty ? [0] : specificMonths;
        return months.length == 1
            ? 'at month ${months[0]}'
            : 'at months ${months.getRange(0, months.length - 2).join(', ')} and ${months.last}';
      case CronMonthType.BETWEEN:
        return 'every month between $betweenStartMonth and $betweenEndMonth';
    }
  }

  List<String> getMonthList() {
    return [
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
  }

  Map<int, String> getMonthMap() {
    return {
      1: 'JAN',
      2: 'FEB',
      3: 'MAR',
      4: 'APR',
      5: 'MAY',
      6: 'JUN',
      7: 'JUL',
      8: 'AUG',
      9: 'SEP',
      10: 'OCT',
      11: 'NOV',
      12: 'DEC',
    };
  }
}
