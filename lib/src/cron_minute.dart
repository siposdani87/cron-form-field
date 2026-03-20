import 'package:cron_form_field/src/enums/cron_minute_type.dart';
import 'package:cron_form_field/src/util.dart';

import 'package:cron_form_field/src/cron_part.dart';

class CronMinute implements CronPart {
  late CronMinuteType type;
  late int everyMinute;
  late int? everyStartMinute;
  late List<int> specificMinutes;
  late int betweenStartMinute;
  late int betweenEndMinute;

  CronMinute(String originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 0-59
    everyMinute = 1;
    everyStartMinute = null;
    specificMinutes = [startIndex];
    betweenStartMinute = startIndex;
    betweenEndMinute = startIndex;
  }

  @override
  void reset() {
    type = CronMinuteType.every;
    setDefaults();
  }

  void setEveryMinute() {
    type = CronMinuteType.every;
  }

  void setEveryMinuteStartAt(int minute, [int? startMinute]) {
    type = CronMinuteType.everyStartAt;
    everyMinute = minute;
    everyStartMinute = startMinute;
  }

  void setSpecificMinutes(List<int> minutes) {
    type = CronMinuteType.specific;
    specificMinutes = minutes;
  }

  void setBetweenMinutes(int startMinute, int endMinute) {
    type = CronMinuteType.between;
    betweenStartMinute = startMinute;
    betweenEndMinute = endMinute;
  }

  void _setValue(String value) {
    if (!validate(value)) {
      throw ArgumentError('Invalid minute part of expression!');
    }
    type = _getType(value);
    switch (type) {
      case CronMinuteType.every:
        break;
      case CronMinuteType.everyStartAt:
        var parts = value.split('/');
        everyStartMinute = parts[0] == '*' ? null : int.parse(parts[0]);
        everyMinute = int.parse(parts[1]);
        break;
      case CronMinuteType.specific:
        specificMinutes = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronMinuteType.between:
        var parts = value.split('-');
        betweenStartMinute = int.parse(parts[0]);
        betweenEndMinute = int.parse(parts[1]);
        break;
    }
  }

  CronMinuteType _getType(String value) {
    if (value.contains('/')) {
      return CronMinuteType.everyStartAt;
    } else if (value.contains('*')) {
      return CronMinuteType.every;
    } else if (value.contains('-')) {
      return CronMinuteType.between;
    }

    return CronMinuteType.specific;
  }

  @override
  String toString() {
    switch (type) {
      case CronMinuteType.every:
        return '*';
      case CronMinuteType.everyStartAt:
        return '${everyStartMinute ?? '*'}/$everyMinute';
      case CronMinuteType.specific:
        return (specificMinutes.isEmpty ? [startIndex] : specificMinutes)
            .join(',');
      case CronMinuteType.between:
        return '$betweenStartMinute-$betweenEndMinute';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronMinuteType.every:
        return 'every minute';
      case CronMinuteType.everyStartAt:
        var startMinute = everyStartMinute ?? 0;
        return startMinute > 0
            ? 'every $everyMinute minutes starting at $startMinute'
            : 'every $everyMinute minutes';
      case CronMinuteType.specific:
        var minutes = specificMinutes.isEmpty ? [startIndex] : specificMinutes;
        return minutes.length == 1
            ? 'at minute ${minutes[0]}'
            : 'at minutes ${minutes.getRange(0, minutes.length - 1).join(', ')} and ${minutes.last}';
      case CronMinuteType.between:
        return 'every minute between $betweenStartMinute and $betweenEndMinute';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(r'^(\*|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9]{1,2}(-[0-9]{1,2}|)(,[0-9]{1,2})*)$')
        .hasMatch(part);
  }

  Map<int, String> getEveryMinuteMap() {
    return rangeListToMap(generateRangeList(1, 60));
  }

  Map<int, String> getMinuteMap() {
    return rangeListToMap(generateRangeList(0, 60), converter: (int num) {
      return num.toString().padLeft(2, '0');
    });
  }

  @override
  int get startIndex {
    return 0;
  }
}
