import 'util.dart';

import 'cron_day.dart';
import 'cron_day_type.dart';
import 'cron_entity.dart';
import 'cron_part.dart';

class DayOfWeek extends CronEntity implements CronPart {
  CronDay parent;
  late int everyDay;
  late int? everyStartDay;
  late List<String> specificWeekdays;
  late int xthWeekday;
  late int xthWeeks;
  late int? lastDay;

  DayOfWeek(String originalValue, this.parent) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory DayOfWeek.fromString(String dayOfWeekExpression, CronDay parent) {
    return DayOfWeek(dayOfWeekExpression, parent);
  }

  void setDefaults() {
    // 0-6, SUN-SAT
    everyDay = 1;
    everyStartDay = null;
    specificWeekdays = ['SUN'];
    xthWeekday = 0;
    xthWeeks = 1;
    lastDay = null;
  }

  void reset() {
    parent.type = CronDayType.EVERY_WEEK;
    setDefaults();
  }

  void setEveryWeek() {
    parent.type = CronDayType.EVERY_WEEK;
  }

  void setEveryStartAtWeek(int day, int? startDay) {
    parent.type = CronDayType.EVERY_START_AT_WEEK;
    everyDay = day;
    everyStartDay = startDay;
  }

  void setSpecificDayOfWeek(List<String> weekdays) {
    parent.type = CronDayType.SPECIFIC_DAY_OF_WEEK;
    specificWeekdays = weekdays;
  }

  void toggleSpecificWeekday(String weekday) {
    var weekdays = specificWeekdays.toList();
    if (weekdays.contains(weekday)) {
      weekdays.remove(weekday);
    } else {
      weekdays.add(weekday);
    }
    setSpecificDayOfWeek(weekdays);
  }

  void setXthDayOfMonth(int weekday, int weeks) {
    parent.type = CronDayType.XTH_DAY_OF_MONTH;
    xthWeekday = weekday;
    xthWeeks = weeks;
  }

  void setLastXDayOfMonth(int? day) {
    parent.type = CronDayType.LAST_X_DAY_OF_MONTH;
    lastDay = day;
  }

  void _setValue(String value) {
    switch (parent.type) {
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
        specificWeekdays = value.split(',').toList();
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
        xthWeekday = int.parse(parts[0]);
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

  String toString() {
    switch (parent.type) {
      case CronDayType.EVERY_WEEK:
        return '*';
      case CronDayType.EVERY_MONTH:
        return '?';
      case CronDayType.EVERY_START_AT_WEEK:
        return '${everyStartDay ?? '*'}/$everyDay';
      case CronDayType.EVERY_START_AT_MONTH:
        return '?';
      case CronDayType.SPECIFIC_DAY_OF_WEEK:
        return specificWeekdays.isEmpty ? 'SUN' : specificWeekdays.join(',');
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
        return '$xthWeekday#$xthWeeks';
    }
  }

  String toReadableString() {
    switch (parent.type) {
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
        var days = specificWeekdays.isEmpty ? ['SUN'] : specificWeekdays;
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
        return 'on the ${serialNumberName(xthWeeks)} $xthWeekday of the month';
    }
  }

  List<String> getWeekdayList() {
    return ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  }

  Map<int, String> getWeekdayMap() {
    return {
      0: 'SUN',
      1: 'MON',
      2: 'TUE',
      3: 'WED',
      4: 'THU',
      5: 'FRI',
      6: 'SAT',
    };
  }

  Map<int, String> getWeeksMap() {
    return {
      1: 'FIRST',
      2: 'SECOND',
      3: 'THIRD',
      4: 'FOURTH',
      5: 'FIFTH',
    };
  }
}
