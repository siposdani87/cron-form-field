import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_second_type.dart';

class CronSecond implements CronPart {
  late CronSecondType type;
  late int everySecond;
  late int? everyStartSecond;
  late List<int> specificSeconds;
  late int betweenStartSecond;
  late int betweenEndSecond;

  CronSecond(String? originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 0-59
    everySecond = 1;
    everyStartSecond = null;
    specificSeconds = [startIndex];
    betweenStartSecond = startIndex;
    betweenEndSecond = startIndex;
  }

  @override
  void reset() {
    type = CronSecondType.every;
    setDefaults();
  }

  void setEverySecond() {
    type = CronSecondType.every;
  }

  void setEverySecondStartAt(int second, [int? startSecond]) {
    type = CronSecondType.everyStartAt;
    everySecond = second;
    everyStartSecond = startSecond;
  }

  void setSpecificSeconds(List<int> seconds) {
    type = CronSecondType.specific;
    specificSeconds = seconds;
  }

  void setBetweenSeconds(int startSecond, int endSecond) {
    type = CronSecondType.between;
    betweenStartSecond = startSecond;
    betweenEndSecond = endSecond;
  }

  void _setValue(String? value) {
    type = _getType(value);
    if (value == null) {
      return;
    }
    if (!validate(value)) {
      throw ArgumentError('Invalid second part of expression!');
    }
    switch (type) {
      case CronSecondType.every:
        break;
      case CronSecondType.everyStartAt:
        var parts = value.split('/');
        everyStartSecond = parts[0] == '*' ? null : int.parse(parts[0]);
        everySecond = int.parse(parts[1]);
        break;
      case CronSecondType.specific:
        specificSeconds = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronSecondType.between:
        var parts = value.split('-');
        betweenStartSecond = int.parse(parts[0]);
        betweenEndSecond = int.parse(parts[1]);
        break;
      case CronSecondType.none:
        break;
    }
  }

  CronSecondType _getType(String? value) {
    if (value == null) {
      return CronSecondType.none;
    }
    if (value.contains('/')) {
      return CronSecondType.everyStartAt;
    } else if (value.contains('*')) {
      return CronSecondType.every;
    } else if (value.contains('-')) {
      return CronSecondType.between;
    }

    return CronSecondType.specific;
  }

  @override
  String toString() {
    switch (type) {
      case CronSecondType.every:
        return '*';
      case CronSecondType.everyStartAt:
        return '${everyStartSecond ?? '*'}/$everySecond';
      case CronSecondType.specific:
        return (specificSeconds.isEmpty ? [startIndex] : specificSeconds)
            .join(',');
      case CronSecondType.between:
        return '$betweenStartSecond-$betweenEndSecond';
      case CronSecondType.none:
        return '';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronSecondType.every:
        return 'every second';
      case CronSecondType.everyStartAt:
        var startSecond = everyStartSecond ?? 0;
        return startSecond > 0
            ? 'every $everySecond seconds starting at $startSecond'
            : 'every $everySecond seconds';
      case CronSecondType.specific:
        var seconds = specificSeconds.isEmpty ? [startIndex] : specificSeconds;
        return seconds.length == 1
            ? 'at second ${seconds[0]}'
            : 'at seconds ${seconds.getRange(0, seconds.length - 1).join(', ')} and ${seconds.last}';
      case CronSecondType.between:
        return 'every second between $betweenStartSecond and $betweenEndSecond';
      case CronSecondType.none:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(r'^(\*|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9]{1,2}(-[0-9]{1,2}|)(,[0-9]{1,2})*)$')
        .hasMatch(part);
  }

  @override
  int get startIndex {
    return 0;
  }
}
