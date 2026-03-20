import 'package:cron_form_field/src/util.dart';

import 'package:cron_form_field/src/cron_day.dart';
import 'package:cron_form_field/src/enums/cron_day_type.dart';
import 'package:cron_form_field/src/cron_part.dart';

class DayOfMonth implements CronPart {
  CronDay cronDay;
  late int everyDay;
  late int? everyStartDay;
  late List<int> specificMonthDays;
  late int? lastDay;
  late int nearestWeekday;
  late int dayBefore;

  DayOfMonth(String originalValue, this.cronDay) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 1-31
    everyDay = 1;
    everyStartDay = null;
    specificMonthDays = [startIndex];
    lastDay = null;
    nearestWeekday = 1;
    dayBefore = 1;
  }

  @override
  void reset() {
    cronDay.type = CronDayType.everyMonth;
    setDefaults();
  }

  void setEveryMonth() {
    cronDay.type = CronDayType.everyMonth;
  }

  void setEveryStartAtMonth(int day, [int? startDay]) {
    cronDay.type = CronDayType.everyStartAtMonth;
    everyDay = day;
    everyStartDay = startDay;
  }

  void setSpecificDayOfMonth(List<int> days) {
    cronDay.type = CronDayType.specificDayOfMonth;
    specificMonthDays = days;
  }

  void setLastDayOfMonth(int day) {
    cronDay.type = CronDayType.lastDayOfMonth;
    lastDay = day;
  }

  void setNearestWeekdayOfMonth(int day) {
    cronDay.type = CronDayType.nearestWeekdayOfMonth;
    nearestWeekday = day;
  }

  void setDayBeforeEndOfMonth(int day) {
    cronDay.type = CronDayType.dayBeforeEndOfMonth;
    dayBefore = day;
  }

  void setLastWeekdayOfMonth() {
    cronDay.type = CronDayType.lastWeekdayOfMonth;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid day of month part of expression!');
    }
    switch (cronDay.type) {
      case CronDayType.everyWeek:
        break;
      case CronDayType.everyMonth:
        break;
      case CronDayType.everyStartAtWeek:
        break;
      case CronDayType.everyStartAtMonth:
        var parts = value.split('/');
        everyStartDay = parts[0] == '*' ? null : int.parse(parts[0]);
        everyDay = int.parse(parts[1]);
        break;
      case CronDayType.specificDayOfWeek:
        break;
      case CronDayType.specificDayOfMonth:
        specificMonthDays = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronDayType.lastDayOfMonth:
        lastDay = value.length == 1 ? null : int.parse(value.split('L')[0]);
        break;
      case CronDayType.lastWeekdayOfMonth:
        break;
      case CronDayType.lastXDayOfMonth:
        break;
      case CronDayType.dayBeforeEndOfMonth:
        dayBefore = int.parse(value.split('-')[1]);
        break;
      case CronDayType.nearestWeekdayOfMonth:
        nearestWeekday = int.parse(value.split('W')[0]);
        break;
      case CronDayType.xthDayOfMonth:
        break;
    }
  }

  static CronDayType getType(String value) {
    if (value.contains('/')) {
      return CronDayType.everyStartAtMonth;
    } else if (value.contains('*')) {
      return CronDayType.everyMonth;
    } else if (value.contains('LW')) {
      return CronDayType.lastWeekdayOfMonth;
    } else if (value.contains('L-')) {
      return CronDayType.dayBeforeEndOfMonth;
    } else if (value.contains('L')) {
      return CronDayType.lastDayOfMonth;
    } else if (value.contains('W')) {
      return CronDayType.nearestWeekdayOfMonth;
    }

    return CronDayType.specificDayOfMonth;
  }

  @override
  String toString() {
    switch (cronDay.type) {
      case CronDayType.everyWeek:
        return '?';
      case CronDayType.everyMonth:
        return '*';
      case CronDayType.everyStartAtWeek:
        return '?';
      case CronDayType.everyStartAtMonth:
        return '${everyStartDay ?? '*'}/$everyDay';
      case CronDayType.specificDayOfWeek:
        return '?';
      case CronDayType.specificDayOfMonth:
        return (specificMonthDays.isEmpty ? [startIndex] : specificMonthDays)
            .join(',');
      case CronDayType.lastDayOfMonth:
        return '${lastDay ?? ''}L';
      case CronDayType.lastWeekdayOfMonth:
        return 'LW';
      case CronDayType.lastXDayOfMonth:
        return '?';
      case CronDayType.dayBeforeEndOfMonth:
        return 'L-$dayBefore';
      case CronDayType.nearestWeekdayOfMonth:
        return '${nearestWeekday}W';
      case CronDayType.xthDayOfMonth:
        return '?';
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
        return '';
      case CronDayType.everyStartAtMonth:
        var startDay = everyStartDay ?? 0;
        return startDay > 0
            ? 'every $everyDay days starting on the ${serialNumberName(startDay)}'
            : 'every $everyDay days';
      case CronDayType.specificDayOfWeek:
        return '?';
      case CronDayType.specificDayOfMonth:
        var days = specificMonthDays.isEmpty ? [startIndex] : specificMonthDays;
        return days.length == 1
            ? 'on the ${serialNumberName(days[0])} day'
            : 'on the ${days.getRange(0, days.length - 1).join(', ')} and ${days.last} day';
      case CronDayType.lastDayOfMonth:
        return 'on the ${lastDay ?? 'last'} day of the month';
      case CronDayType.lastWeekdayOfMonth:
        return 'on the last weekday of the month';
      case CronDayType.lastXDayOfMonth:
        return '';
      case CronDayType.dayBeforeEndOfMonth:
        return '$dayBefore days before the end of the month';
      case CronDayType.nearestWeekdayOfMonth:
        return 'on the nearest weekday to the ${serialNumberName(nearestWeekday)} of the month';
      case CronDayType.xthDayOfMonth:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(r'^(\*|\?|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9]{1,2}(,[0-9]{1,2})*|[0-9]*L|LW|L-[0-9]{1,2}|[0-9]{1,2}W)$')
        .hasMatch(part);
  }

  Map<int, String> getDayMap() {
    return rangeListToMap(generateRangeList(1, 32));
  }

  @override
  int get startIndex {
    return 1;
  }
}
