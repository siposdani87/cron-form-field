import 'package:cron_form_field/src/enums/cron_hour_type.dart';
import 'package:cron_form_field/src/util.dart';

import 'package:cron_form_field/src/cron_part.dart';

class CronHour implements CronPart {
  late CronHourType type;
  late int everyHour;
  late int? everyStartHour;
  late List<int> specificHours;
  late int betweenStartHour;
  late int betweenEndHour;

  CronHour(String originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 0-23
    everyHour = 1;
    everyStartHour = null;
    specificHours = [startIndex];
    betweenStartHour = startIndex;
    betweenEndHour = startIndex;
  }

  @override
  void reset() {
    type = CronHourType.every;
    setDefaults();
  }

  void setEveryHour() {
    type = CronHourType.every;
  }

  void setEveryHourStartAt(int hour, [int? startHour]) {
    type = CronHourType.everyStartAt;
    everyHour = hour;
    everyStartHour = startHour;
  }

  void setSpecificHours(List<int> hours) {
    type = CronHourType.specific;
    specificHours = hours;
  }

  void setBetweenHours(int startHour, int endHour) {
    type = CronHourType.between;
    betweenStartHour = startHour;
    betweenEndHour = endHour;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid hour part of expression!');
    }
    type = _getType(value);
    switch (type) {
      case CronHourType.every:
        break;
      case CronHourType.everyStartAt:
        var parts = value.split('/');
        everyStartHour = parts[0] == '*' ? null : int.parse(parts[0]);
        everyHour = int.parse(parts[1]);
        break;
      case CronHourType.specific:
        specificHours = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronHourType.between:
        var parts = value.split('-');
        betweenStartHour = int.parse(parts[0]);
        betweenEndHour = int.parse(parts[1]);
        break;
    }
  }

  CronHourType _getType(String value) {
    if (value.contains('/')) {
      return CronHourType.everyStartAt;
    } else if (value.contains('*')) {
      return CronHourType.every;
    } else if (value.contains('-')) {
      return CronHourType.between;
    }

    return CronHourType.specific;
  }

  @override
  String toString() {
    switch (type) {
      case CronHourType.every:
        return '*';
      case CronHourType.everyStartAt:
        return '${everyStartHour ?? '*'}/$everyHour';
      case CronHourType.specific:
        return (specificHours.isEmpty ? [startIndex] : specificHours).join(',');
      case CronHourType.between:
        return '$betweenStartHour-$betweenEndHour';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronHourType.every:
        return 'every hour';
      case CronHourType.everyStartAt:
        var startHour = everyStartHour ?? 0;
        return startHour > 0
            ? 'every $everyHour hours starting at $startHour'
            : 'every $everyHour hours';
      case CronHourType.specific:
        var hours = specificHours.isEmpty ? [startIndex] : specificHours;
        return hours.length == 1
            ? 'at hour ${hours[0]}'
            : 'at hours ${hours.getRange(0, hours.length - 1).join(', ')} and ${hours.last}';
      case CronHourType.between:
        return 'every hour between $betweenStartHour and $betweenEndHour';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(r'^(\*|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9]{1,2}(-[0-9]{1,2}|)(,[0-9]{1,2})*)$')
        .hasMatch(part);
  }

  Map<int, String> getHourMap() {
    return rangeListToMap(generateRangeList(0, 24), converter: (int num) {
      return num.toString().padLeft(2, '0');
    });
  }

  @override
  int get startIndex {
    return 0;
  }
}
