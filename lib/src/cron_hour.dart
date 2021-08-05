import 'package:cron_form_field/src/util.dart';

import 'cron_entity.dart';
import 'cron_part.dart';

enum CronHourType { EVERY, EVERY_START_AT, SPECIFIC, BETWEEN }

class CronHour extends CronEntity implements CronPart {
  late CronHourType type;
  late int everyHour;
  late int? everyStartHour;
  late List<int> specificHours;
  late int betweenStartHour;
  late int betweenEndHour;

  CronHour(String originalValue) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory CronHour.fromString(String hourExpression) {
    return CronHour(hourExpression);
  }

  void setDefaults() {
    // 0-23
    everyHour = 1;
    everyStartHour = null;
    specificHours = [0];
    betweenStartHour = 0;
    betweenEndHour = 0;
  }

  void reset() {
    type = CronHourType.EVERY;
    setDefaults();
  }

  void setEveryHour() {
    type = CronHourType.EVERY;
  }

  void setEveryHourStartAt(int hour, int? startHour) {
    type = CronHourType.EVERY_START_AT;
    everyHour = hour;
    everyStartHour = startHour;
  }

  void setSpecificHours(List<int> hours) {
    type = CronHourType.SPECIFIC;
    specificHours = hours;
  }

  void setBetweenHours(int startHour, int endHour) {
    type = CronHourType.BETWEEN;
    betweenStartHour = startHour;
    betweenEndHour = endHour;
  }

  void _setValue(String value) {
    type = _getType(value);
    switch (type) {
      case CronHourType.EVERY:
        break;
      case CronHourType.EVERY_START_AT:
        var parts = value.split('/');
        everyStartHour = parts[0] == '*' ? null : int.parse(parts[0]);
        everyHour = int.parse(parts[1]);
        break;
      case CronHourType.SPECIFIC:
        specificHours = value.split(',').map((e) => int.parse(e)).toList();
        break;
      case CronHourType.BETWEEN:
        var parts = value.split('-');
        betweenStartHour = int.parse(parts[0]);
        betweenEndHour = int.parse(parts[1]);
        break;
    }
  }

  CronHourType _getType(String value) {
    if (value.contains('/')) {
      return CronHourType.EVERY_START_AT;
    } else if (value.contains('*')) {
      return CronHourType.EVERY;
    } else if (value.contains('-')) {
      return CronHourType.BETWEEN;
    }

    return CronHourType.SPECIFIC;
  }

  String toString() {
    switch (type) {
      case CronHourType.EVERY:
        return '*';
      case CronHourType.EVERY_START_AT:
        return '${everyStartHour ?? '*'}/$everyHour';
      case CronHourType.SPECIFIC:
        return specificHours.isEmpty ? '0' : specificHours.join(',');
      case CronHourType.BETWEEN:
        return '$betweenStartHour-$betweenEndHour';
    }
  }

  String toReadableString() {
    switch (type) {
      case CronHourType.EVERY:
        return 'every hour';
      case CronHourType.EVERY_START_AT:
        var startHour = everyStartHour ?? 0;
        return startHour > 0
            ? 'every $everyHour hours starting at $startHour'
            : 'every $everyHour hours';
      case CronHourType.SPECIFIC:
        var hours = specificHours.isEmpty ? [0] : specificHours;
        return hours.length == 1
            ? 'at hour ${hours[0]}'
            : 'at hours ${hours.getRange(0, hours.length - 2).join(', ')} and ${hours.last}';
      case CronHourType.BETWEEN:
        return 'every hour between $betweenStartHour and $betweenEndHour';
    }
  }

  List<int> getHourList() {
    return range(0, 24);
  }
}
