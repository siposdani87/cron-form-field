import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:cron_form_field/src/enums/cron_expression_type.dart';
import 'package:cron_form_field/src/util.dart';
import 'package:cron_form_field/src/cron_day.dart';
import 'package:cron_form_field/src/enums/cron_day_type.dart';

import 'package:cron_form_field/src/cron_part.dart';

class DayOfWeek implements CronPart {
  CronDay cronDay;
  late int everyDay;
  late int? everyStartDay;
  late List<int> specificWeekdays;
  late int xthWeekday;
  late int xthWeeks;
  late int? lastDay;
  bool useAlternativeValue = false;

  DayOfWeek(String originalValue, this.cronDay) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 0-6, SUN-SAT, (1-7)
    everyDay = 1;
    everyStartDay = null;
    specificWeekdays = [startIndex];
    xthWeekday = startIndex;
    xthWeeks = 1;
    lastDay = null;
  }

  @override
  void reset() {
    cronDay.type = CronDayType.everyWeek;
    setDefaults();
  }

  void setEveryWeek() {
    cronDay.type = CronDayType.everyWeek;
  }

  void setEveryStartAtWeek(int day, [int? startDay]) {
    cronDay.type = CronDayType.everyStartAtWeek;
    everyDay = day;
    everyStartDay = startDay;
  }

  void setSpecificDayOfWeek(List<int> weekdays) {
    cronDay.type = CronDayType.specificDayOfWeek;
    specificWeekdays = weekdays;
  }

  void toggleSpecificWeekday(int weekday) {
    var weekdays = specificWeekdays.toList();
    if (weekdays.contains(weekday)) {
      weekdays.remove(weekday);
    } else {
      weekdays.add(weekday);
    }
    setSpecificDayOfWeek(weekdays);
  }

  void setXthDayOfMonth(int weekday, int weeks) {
    cronDay.type = CronDayType.xthDayOfMonth;
    xthWeekday = weekday;
    xthWeeks = weeks;
  }

  void setLastXDayOfMonth(int? day) {
    cronDay.type = CronDayType.lastXDayOfMonth;
    lastDay = day;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid day of week part of expression!');
    }
    handleAlternativeValue(value);
    switch (cronDay.type) {
      case CronDayType.everyWeek:
        break;
      case CronDayType.everyMonth:
        break;
      case CronDayType.everyStartAtWeek:
        var parts = value.split('/');
        everyStartDay = parts[0] == '*' ? null : int.parse(parts[0]);
        everyDay = int.parse(parts[1]);
        break;
      case CronDayType.everyStartAtMonth:
        break;
      case CronDayType.specificDayOfWeek:
        specificWeekdays = value
            .split(',')
            .map((v) => parseAlternativeValue(v, getWeekdayMap()))
            .toList();
        break;
      case CronDayType.specificDayOfMonth:
        break;
      case CronDayType.lastDayOfMonth:
        break;
      case CronDayType.lastWeekdayOfMonth:
        break;
      case CronDayType.lastXDayOfMonth:
        lastDay = value.length == 1 ? null : int.parse(value.split('L')[0]);
        break;
      case CronDayType.dayBeforeEndOfMonth:
        break;
      case CronDayType.nearestWeekdayOfMonth:
        break;
      case CronDayType.xthDayOfMonth:
        var parts = value.split('#');
        xthWeekday = parseAlternativeValue(parts[0], getWeekdayMap());
        xthWeeks = int.parse(parts[1]);
    }
  }

  static CronDayType getType(String value) {
    if (value.contains('/')) {
      return CronDayType.everyStartAtWeek;
    } else if (value.contains('*')) {
      return CronDayType.everyWeek;
    } else if (value.contains('#')) {
      return CronDayType.xthDayOfMonth;
    } else if (value.contains('L')) {
      return CronDayType.lastXDayOfMonth;
    }

    return CronDayType.specificDayOfWeek;
  }

  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.auto);
  }

  String toFormatString(CronExpressionOutputFormat outputFormat) {
    switch (cronDay.type) {
      case CronDayType.everyWeek:
        return '*';
      case CronDayType.everyMonth:
        return '?';
      case CronDayType.everyStartAtWeek:
        return '${everyStartDay ?? '*'}/$everyDay';
      case CronDayType.everyStartAtMonth:
        return '?';
      case CronDayType.specificDayOfWeek:
        return (specificWeekdays.isEmpty ? [startIndex] : specificWeekdays)
            .map((v) => convertAlternativeValue(
                  outputFormat.isAlternative(useAlternativeValue),
                  v,
                  getWeekdayMap(),
                ))
            .toList()
            .join(',');
      case CronDayType.specificDayOfMonth:
        return '?';
      case CronDayType.lastDayOfMonth:
        return '?';
      case CronDayType.lastWeekdayOfMonth:
        return '?';
      case CronDayType.lastXDayOfMonth:
        return '${lastDay ?? ''}L';
      case CronDayType.dayBeforeEndOfMonth:
        return '?';
      case CronDayType.nearestWeekdayOfMonth:
        return '?';
      case CronDayType.xthDayOfMonth:
        return '${convertAlternativeValue(outputFormat.isAlternative(useAlternativeValue), xthWeekday, getWeekdayMap())}#$xthWeeks';
    }
  }

  @override
  String toReadableString() {
    switch (cronDay.type) {
      case CronDayType.everyWeek:
        return '';
      case CronDayType.everyMonth:
        return '';
      case CronDayType.everyStartAtWeek:
        var startDay = everyStartDay ?? 0;
        return startDay > 0
            ? 'every $everyDay days starting on the $startDay'
            : 'every $everyDay days';
      case CronDayType.everyStartAtMonth:
        return '';
      case CronDayType.specificDayOfWeek:
        var days = (specificWeekdays.isEmpty ? [startIndex] : specificWeekdays)
            .map((v) => convertAlternativeValue(
                  true,
                  v,
                  getWeekdayMap(),
                ))
            .toList();
        return days.length == 1
            ? 'on the ${days[0]} day'
            : 'on the ${days.getRange(0, days.length - 1).join(', ')} and ${days.last} day';
      case CronDayType.specificDayOfMonth:
        return '';
      case CronDayType.lastDayOfMonth:
        return '';
      case CronDayType.lastWeekdayOfMonth:
        return '';
      case CronDayType.lastXDayOfMonth:
        return 'the last ${lastDay ?? 'day'} of the month';
      case CronDayType.dayBeforeEndOfMonth:
        return '';
      case CronDayType.nearestWeekdayOfMonth:
        return '';
      case CronDayType.xthDayOfMonth:
        return 'on the ${serialNumberName(xthWeeks)} ${convertAlternativeValue(true, xthWeekday, getWeekdayMap())} of the month';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(
            r'^(\*|\?|(\*|[0-9])/[0-9]|[0-9A-Z]{1,3}(,[0-9A-Z]{1,3})*|[0-9A-Z]{1,3}#[0-9]|[0-9]*L)$',
            caseSensitive: false)
        .hasMatch(part);
  }

  void handleAlternativeValue(String value) {
    useAlternativeValue = isAlternativeValue(value, getWeekdayMap());
  }

  Map<int, String> getWeekdayMap() {
    final List<String> dayNames = [
      'SUN',
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
    ];

    return getMapFromIndex(dayNames, startIndex);
  }

  Map<int, String> getWeeksMap() {
    final List<String> weeks = ['FIRST', 'SECOND', 'THIRD', 'FOURTH', 'FIFTH'];

    return getMapFromIndex(weeks, 1);
  }

  @override
  int get startIndex {
    return cronDay.expressionType == CronExpressionType.standard ? 0 : 1;
  }
}
