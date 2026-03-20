import 'package:cron_form_field/src/cron_part.dart';

/// The type of value a time-based cron part holds.
enum CronTimePartType { none, every, everyStartAt, specific, between }

/// Base class for time-based cron parts (second, minute, hour).
///
/// Encapsulates the shared parsing, formatting, validation, and readable
/// string logic that is identical across these three part types.
abstract class CronTimePart implements CronPart {
  late CronTimePartType type;
  late int everyValue;
  late int? everyStartValue;
  late List<int> specificValues;
  late int betweenStartValue;
  late int betweenEndValue;

  /// The singular label for readable strings (e.g., "second", "minute", "hour").
  String get label;

  /// The plural label for readable strings (e.g., "seconds", "minutes", "hours").
  String get pluralLabel;

  /// Whether this part supports a [CronTimePartType.none] type (optional parts like second/year).
  bool get supportsNone => false;

  CronTimePart(String? originalValue) {
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    everyValue = 1;
    everyStartValue = null;
    specificValues = [startIndex];
    betweenStartValue = startIndex;
    betweenEndValue = startIndex;
  }

  @override
  void reset() {
    type = CronTimePartType.every;
    setDefaults();
  }

  void setEvery() {
    type = CronTimePartType.every;
  }

  void setEveryStartAt(int value, [int? startValue]) {
    type = CronTimePartType.everyStartAt;
    everyValue = value;
    everyStartValue = startValue;
  }

  void setSpecific(List<int> values) {
    type = CronTimePartType.specific;
    specificValues = values;
  }

  void setBetween(int startValue, int endValue) {
    type = CronTimePartType.between;
    betweenStartValue = startValue;
    betweenEndValue = endValue;
  }

  void _setValue(String? value) {
    type = _getType(value);
    if (value == null) {
      return;
    }
    if (!validate(value)) {
      throw ArgumentError('Invalid $label part of expression!');
    }
    switch (type) {
      case CronTimePartType.every:
        break;
      case CronTimePartType.everyStartAt:
        var parts = value.split('/');
        everyStartValue = parts[0] == '*' ? null : int.parse(parts[0]);
        everyValue = int.parse(parts[1]);
        break;
      case CronTimePartType.specific:
        specificValues = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronTimePartType.between:
        var parts = value.split('-');
        betweenStartValue = int.parse(parts[0]);
        betweenEndValue = int.parse(parts[1]);
        break;
      case CronTimePartType.none:
        break;
    }
  }

  CronTimePartType _getType(String? value) {
    if (value == null && supportsNone) {
      return CronTimePartType.none;
    }
    if (value == null) {
      return CronTimePartType.every;
    }
    if (value.contains('/')) {
      return CronTimePartType.everyStartAt;
    } else if (value.contains('*')) {
      return CronTimePartType.every;
    } else if (value.contains('-')) {
      return CronTimePartType.between;
    }

    return CronTimePartType.specific;
  }

  @override
  String toString() {
    switch (type) {
      case CronTimePartType.every:
        return '*';
      case CronTimePartType.everyStartAt:
        return '${everyStartValue ?? '*'}/$everyValue';
      case CronTimePartType.specific:
        return (specificValues.isEmpty ? [startIndex] : specificValues)
            .join(',');
      case CronTimePartType.between:
        return '$betweenStartValue-$betweenEndValue';
      case CronTimePartType.none:
        return '';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronTimePartType.every:
        return 'every $label';
      case CronTimePartType.everyStartAt:
        var start = everyStartValue ?? 0;
        return start > 0
            ? 'every $everyValue $pluralLabel starting at $start'
            : 'every $everyValue $pluralLabel';
      case CronTimePartType.specific:
        var values = specificValues.isEmpty ? [startIndex] : specificValues;
        return values.length == 1
            ? 'at $label ${values[0]}'
            : 'at $pluralLabel ${values.getRange(0, values.length - 1).join(', ')} and ${values.last}';
      case CronTimePartType.between:
        return 'every $label between $betweenStartValue and $betweenEndValue';
      case CronTimePartType.none:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(
            r'^(\*|(\*|[0-9]{1,2})/[0-9]{1,2}|[0-9]{1,2}(-[0-9]{1,2}|)(,[0-9]{1,2})*)$')
        .hasMatch(part);
  }
}
