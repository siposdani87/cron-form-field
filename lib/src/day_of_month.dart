import 'package:cron_form_field/src/util.dart';
import 'package:cron_form_field/src/cron_entity.dart';
import 'package:cron_form_field/src/cron_day.dart';
import 'package:cron_form_field/src/enums/cron_day_type.dart';
import 'package:cron_form_field/src/cron_part.dart';

class DayOfMonth extends CronEntity implements CronPart {
  CronDay cronDay;
  late int everyDay;
  late int? everyStartDay;
  late List<int> specificMonthDays;
  late int? lastDay;
  late int nearestWeekday;
  late int dayBefore;

  DayOfMonth(String originalValue, this.cronDay) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory DayOfMonth.fromString(String dayOfMonthExpression, CronDay cronDay) {
    return DayOfMonth(dayOfMonthExpression, cronDay);
  }

  @override
  void setDefaults() {
    // 1-31
    everyDay = 1;
    everyStartDay = null;
    specificMonthDays = [1];
    lastDay = null;
    nearestWeekday = 1;
    dayBefore = 1;
  }

  @override
  void reset() {
    cronDay.type = CronDayType.EVERY_MONTH;
    setDefaults();
  }

  void setEveryMonth() {
    cronDay.type = CronDayType.EVERY_MONTH;
  }

  void setEveryStartAtMonth(int day, int? startDay) {
    cronDay.type = CronDayType.EVERY_START_AT_MONTH;
    everyDay = day;
    everyStartDay = startDay;
  }

  void setSpecificDayOfMonth(List<int> days) {
    cronDay.type = CronDayType.SPECIFIC_DAY_OF_MONTH;
    specificMonthDays = days;
  }

  void setLastDayOfMonth(int day) {
    cronDay.type = CronDayType.LAST_DAY_OF_MONTH;
    lastDay = day;
  }

  void setNearestWeekdayOfMonth(int day) {
    cronDay.type = CronDayType.NEAREST_WEEKDAY_OF_MONTH;
    nearestWeekday = day;
  }

  void setDayBeforeEndOfMonth(int day) {
    cronDay.type = CronDayType.DAY_BEFORE_END_OF_MONTH;
    dayBefore = day;
  }

  void setLastWeekdayOfMonth() {
    cronDay.type = CronDayType.LAST_WEEKDAY_OF_MONTH;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid day of month part of expression!');
    }
    switch (cronDay.type) {
      case CronDayType.EVERY_WEEK:
        break;
      case CronDayType.EVERY_MONTH:
        break;
      case CronDayType.EVERY_START_AT_WEEK:
        break;
      case CronDayType.EVERY_START_AT_MONTH:
        var parts = value.split('/');
        everyStartDay = parts[0] == '*' ? null : int.parse(parts[0]);
        everyDay = int.parse(parts[1]);
        break;
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        break;
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        specificMonthDays = value.split(',').map((e) => int.parse(e)).toList();
        break;
      case CronDayType.LAST_DAY_OF_MONTH:
        lastDay = value.length == 1 ? null : int.parse(value.split('L')[0]);
        break;
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        break;
      case CronDayType.LAST_X_DAY_OF_MONTH:
        break;
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        dayBefore = int.parse(value.split('-')[1]);
        break;
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        nearestWeekday = int.parse(value.split('W')[0]);
        break;
      case CronDayType.XTH_DAY_OF_MONTH:
        break;
    }
  }

  static CronDayType getType(String value) {
    if (value.contains('/')) {
      return CronDayType.EVERY_START_AT_MONTH;
    } else if (value.contains('*')) {
      return CronDayType.EVERY_MONTH;
    } else if (value.contains('-')) {
      return CronDayType.DAY_BEFORE_END_OF_MONTH;
    } else if (value.contains('LW')) {
      return CronDayType.LAST_WEEKDAY_OF_MONTH;
    } else if (value.contains('L')) {
      return CronDayType.LAST_DAY_OF_MONTH;
    } else if (value.contains('W')) {
      return CronDayType.NEAREST_WEEKDAY_OF_MONTH;
    }

    return CronDayType.SPECIFIC_DAY_OF_MONTH;
  }

  @override
  String toString() {
    switch (cronDay.type) {
      case CronDayType.EVERY_WEEK:
        return '?';
      case CronDayType.EVERY_MONTH:
        return '*';
      case CronDayType.EVERY_START_AT_WEEK:
        return '?';
      case CronDayType.EVERY_START_AT_MONTH:
        return '${everyStartDay ?? '*'}/$everyDay';
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        return '?';
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        return (specificMonthDays.isEmpty ? [1] : specificMonthDays).join(',');
      case CronDayType.LAST_DAY_OF_MONTH:
        return '${lastDay ?? ''}L';
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        return 'LW';
      case CronDayType.LAST_X_DAY_OF_MONTH:
        return '?';
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        return 'L-$dayBefore';
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        return '${nearestWeekday}W';
      case CronDayType.XTH_DAY_OF_MONTH:
        return '?';
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
        return '';
      case CronDayType.EVERY_START_AT_MONTH:
        var startDay = everyStartDay ?? 0;
        return startDay > 0
            ? 'every $everyDay days starting on the ${serialNumberName(startDay)}'
            : 'every $everyDay days';
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        return '?';
      case CronDayType.SPECIFIC_DAY_OF_MONTH:
        var days = specificMonthDays.isEmpty ? [0] : specificMonthDays;
        return days.length == 1
            ? 'on the ${serialNumberName(days[0])} day'
            : 'on the ${days.getRange(0, days.length - 2).join(', ')} and ${days.last} day';
      case CronDayType.LAST_DAY_OF_MONTH:
        return 'on the ${lastDay ?? 'last'} day of the month';
      case CronDayType.LAST_WEEKDAY_OF_MONTH:
        return 'on the last weekday of the month';
      case CronDayType.LAST_X_DAY_OF_MONTH:
        return '';
      case CronDayType.DAY_BEFORE_END_OF_MONTH:
        return '$dayBefore days before the end of the month';
      case CronDayType.NEAREST_WEEKDAY_OF_MONTH:
        return 'on the nearest weekday to the ${serialNumberName(nearestWeekday)} of the month';
      case CronDayType.XTH_DAY_OF_MONTH:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return true;
  }

  Map<int, String> getDayMap() {
    return rangeListToMap(generateRangeList(1, 32));
  }
}
