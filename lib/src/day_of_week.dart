import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:cron_form_field/src/enums/cron_expression_type.dart';
import 'package:cron_form_field/src/util.dart';
import 'package:cron_form_field/src/cron_day.dart';
import 'package:cron_form_field/src/enums/cron_day_type.dart';
import 'package:cron_form_field/src/cron_entity.dart';
import 'package:cron_form_field/src/cron_part.dart';

class DayOfWeek extends CronEntity implements CronPart {
  CronDay cronDay;
  late int everyDay;
  late int? everyStartDay;
  late List<int> specificWeekdays;
  late int xthWeekday;
  late int xthWeeks;
  late int? lastDay;
  bool useAlternativeValue = false;

  DayOfWeek(String originalValue, this.cronDay) : super(originalValue) {
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
    cronDay.type = CronDayType.EVERY_WEEK;
    setDefaults();
  }

  void setEveryWeek() {
    cronDay.type = CronDayType.EVERY_WEEK;
  }

  void setEveryStartAtWeek(int day, [int? startDay]) {
    cronDay.type = CronDayType.EVERY_START_AT_WEEK;
    everyDay = day;
    everyStartDay = startDay;
  }

  void setSpecificDayOfWeek(List<int> weekdays) {
    cronDay.type = CronDayType.SPECIFIC_DAY_OF_WEEK;
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
    cronDay.type = CronDayType.XTH_DAY_OF_MONTH;
    xthWeekday = weekday;
    xthWeeks = weeks;
  }

  void setLastXDayOfMonth(int? day) {
    cronDay.type = CronDayType.LAST_X_DAY_OF_MONTH;
    lastDay = day;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid day of week part of expression!');
    }
    handleAlternativeValue(value);
    switch (cronDay.type) {
      case CronDayType.EVERY_WEEK:
        break;
      case CronDayType.EVERY_MONTH:
        break;
      case CronDayType.EVERY_START_AT_WEEK:
        var parts = value.split('/');
        everyStartDay = parts[0] == '*' ? null : int.parse(parts[0]);
        everyDay = int.parse(parts[1]);
        break;
      case CronDayType.EVERY_START_AT_MONTH:
        break;
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        specificWeekdays = value
            .split(',')
            .map((v) => parseAlternativeValue(v, getWeekdayMap()))
            .toList();
        break;
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        break;
      case CronDayType.LAST_DAY_OF_MONTH:
        break;
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        break;
      case CronDayType.LAST_X_DAY_OF_MONTH:
        lastDay = value.length == 1 ? null : int.parse(value.split('L')[0]);
        break;
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        break;
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        break;
      case CronDayType.XTH_DAY_OF_MONTH:
        var parts = value.split('#');
        xthWeekday = parseAlternativeValue(parts[0], getWeekdayMap());
        xthWeeks = int.parse(parts[1]);
    }
  }

  static CronDayType getType(String value) {
    if (value.contains('/')) {
      return CronDayType.EVERY_START_AT_WEEK;
    } else if (value.contains('*')) {
      return CronDayType.EVERY_WEEK;
    } else if (value.contains('#')) {
      return CronDayType.XTH_DAY_OF_MONTH;
    } else if (value.contains('L')) {
      return CronDayType.LAST_X_DAY_OF_MONTH;
    }

    return CronDayType.SPECIFIC_DAY_OF_WEEK;
  }

  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.AUTO);
  }

  String toFormatString(CronExpressionOutputFormat outputFormat) {
    switch (cronDay.type) {
      case CronDayType.EVERY_WEEK:
        return '*';
      case CronDayType.EVERY_MONTH:
        return '?';
      case CronDayType.EVERY_START_AT_WEEK:
        return '${everyStartDay ?? '*'}/$everyDay';
      case CronDayType.EVERY_START_AT_MONTH:
        return '?';
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        return (specificWeekdays.isEmpty ? [startIndex] : specificWeekdays)
            .map((v) => convertAlternativeValue(
                  outputFormat.isAlternative(useAlternativeValue),
                  v,
                  getWeekdayMap(),
                ))
            .toList()
            .join(',');
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        return '?';
      case CronDayType.LAST_DAY_OF_MONTH:
        return '?';
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        return '?';
      case CronDayType.LAST_X_DAY_OF_MONTH:
        return '${lastDay ?? ''}L';
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        return '?';
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        return '?';
      case CronDayType.XTH_DAY_OF_MONTH:
        return '${convertAlternativeValue(outputFormat.isAlternative(useAlternativeValue), xthWeekday, getWeekdayMap())}#$xthWeeks';
    }
  }

  @override
  String toReadableString() {
    switch (cronDay.type) {
      case CronDayType.EVERY_WEEK:
        return '';
      case CronDayType.EVERY_MONTH:
        return '';
      case CronDayType.EVERY_START_AT_WEEK:
        var startDay = everyStartDay ?? 0;
        return startDay > 0
            ? 'every $everyDay days starting on the $startDay'
            : 'every $everyDay days';
      case CronDayType.EVERY_START_AT_MONTH:
        return '';
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        var days = (specificWeekdays.isEmpty ? [startIndex] : specificWeekdays)
            .map((v) => convertAlternativeValue(
                  true,
                  v,
                  getWeekdayMap(),
                ))
            .toList();
        return days.length == 1
            ? 'on the ${days[0]} day'
            : 'on the ${days.getRange(0, days.length - 2).join(', ')} and ${days.last} day';
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        return '';
      case CronDayType.LAST_DAY_OF_MONTH:
        return '';
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        return '';
      case CronDayType.LAST_X_DAY_OF_MONTH:
        return 'the last ${lastDay ?? 'day'} of the month';
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        return '';
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        return '';
      case CronDayType.XTH_DAY_OF_MONTH:
        return 'on the ${serialNumberName(xthWeeks)} ${convertAlternativeValue(true, xthWeekday, getWeekdayMap())} of the month';
    }
  }

  @override
  bool validate(String part) {
    return true;
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
    return cronDay.expressionType == CronExpressionType.STANDARD ? 0 : 1;
  }
}
