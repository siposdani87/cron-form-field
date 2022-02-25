import 'package:cron_form_field/src/cron_entity.dart';
import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_second_type.dart';

class CronSecond extends CronEntity implements CronPart {
  late CronSecondType type;
  late int everySecond;
  late int? everyStartSecond;
  late List<int> specificSeconds;
  late int betweenStartSecond;
  late int betweenEndSecond;

  CronSecond(String? originalValue) : super(originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  factory CronSecond.fromString(String? secondExpression) {
    return CronSecond(secondExpression);
  }

  @override
  void setDefaults() {
    everySecond = 1;
    everyStartSecond = null;
    specificSeconds = [0]; // 0-59
    betweenStartSecond = 0;
    betweenEndSecond = 0;
  }

  @override
  void reset() {
    type = CronSecondType.EVERY;
    setDefaults();
  }

  void setEverySecond() {
    type = CronSecondType.EVERY;
  }

  void setEverySecondStartAt(int second, int? startSecond) {
    type = CronSecondType.EVERY_START_AT;
    everySecond = second;
    everyStartSecond = startSecond;
  }

  void setSpecificSeconds(List<int> seconds) {
    type = CronSecondType.SPECIFIC;
    specificSeconds = seconds;
  }

  void setBetweenSeconds(int startSecond, int endSecond) {
    type = CronSecondType.BETWEEN;
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
      case CronSecondType.EVERY:
        break;
      case CronSecondType.EVERY_START_AT:
        var parts = value.split('/');
        everyStartSecond = parts[0] == '*' ? null : int.parse(parts[0]);
        everySecond = int.parse(parts[1]);
        break;
      case CronSecondType.SPECIFIC:
        specificSeconds = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronSecondType.BETWEEN:
        var parts = value.split('-');
        betweenStartSecond = int.parse(parts[0]);
        betweenEndSecond = int.parse(parts[1]);
        break;
      case CronSecondType.NONE:
        break;
    }
  }

  CronSecondType _getType(String? value) {
    if (value == null) {
      return CronSecondType.NONE;
    }
    if (value.contains('/')) {
      return CronSecondType.EVERY_START_AT;
    } else if (value.contains('*')) {
      return CronSecondType.EVERY;
    } else if (value.contains('-')) {
      return CronSecondType.BETWEEN;
    }

    return CronSecondType.SPECIFIC;
  }

  @override
  String toString() {
    switch (type) {
      case CronSecondType.EVERY:
        return '*';
      case CronSecondType.EVERY_START_AT:
        return '${everyStartSecond ?? '*'}/$everySecond';
      case CronSecondType.SPECIFIC:
        return (specificSeconds.isEmpty ? [0] : specificSeconds).join(',');
      case CronSecondType.BETWEEN:
        return '$betweenStartSecond-$betweenEndSecond';
      case CronSecondType.NONE:
        return '';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronSecondType.EVERY:
        return 'every second';
      case CronSecondType.EVERY_START_AT:
        var startSecond = everyStartSecond ?? 0;
        return startSecond > 0
            ? 'every $everySecond seconds starting at $startSecond'
            : 'every $everySecond seconds';
      case CronSecondType.SPECIFIC:
        var seconds = specificSeconds.isEmpty ? [0] : specificSeconds;
        return seconds.length == 1
            ? 'at second ${seconds[0]}'
            : 'at seconds ${seconds.getRange(0, seconds.length - 2).join(', ')} and ${seconds.last}';
      case CronSecondType.BETWEEN:
        return 'every second between $betweenStartSecond and $betweenEndSecond';
      case CronSecondType.NONE:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return true;
  }
}
