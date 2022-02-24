import 'package:cron_form_field/src/cron_entity.dart';
import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_year_type.dart';

class CronYear extends CronEntity implements CronPart {
  late CronYearType type;
  late int? everyYear;
  late int? everyStartYear;
  late List<int> specificYears;
  late int betweenStartYear;
  late int betweenEndYear;
  late int currentYear;

  CronYear(String? originalValue) : super(originalValue) {
    currentYear = DateTime.now().year;
    setDefaults();
    _setValue(originalValue);
  }

  factory CronYear.fromString(String? yearExpression) {
    return CronYear(yearExpression);
  }

  @override
  void setDefaults() {
    everyYear = null;
    everyStartYear = null;
    specificYears = [currentYear];
    betweenStartYear = 0;
    betweenEndYear = 0;
  }

  @override
  void reset() {
    type = CronYearType.EVERY;
    setDefaults();
  }

  void setEveryYear() {
    type = CronYearType.EVERY;
  }

  void setEveryYearStartAt(int? year, int? startYear) {
    type = CronYearType.EVERY_START_AT;
    everyYear = year;
    everyStartYear = startYear;
  }

  void setSpecificYears(List<int> years) {
    type = CronYearType.SPECIFIC;
    specificYears = years;
  }

  void setBetweenYears(int startYear, int endYear) {
    type = CronYearType.BETWEEN;
    betweenStartYear = startYear;
    betweenEndYear = endYear;
  }

  void _setValue(String? value) {
    type = _getType(value);
    if (value == null) {
      return;
    }
    if (!validate(value)) {
      throw ArgumentError('Invalid year part of expression!');
    }
    switch (type) {
      case CronYearType.EVERY:
        break;
      case CronYearType.EVERY_START_AT:
        var parts = value.split('/');
        everyStartYear = parts[0] == '*' ? null : int.parse(parts[0]);
        everyYear = parts[1] == '*' ? null : int.parse(parts[1]);
        break;
      case CronYearType.SPECIFIC:
        specificYears = value.split(',').map((e) => int.parse(e)).toList();
        break;
      case CronYearType.BETWEEN:
        var parts = value.split('-');
        betweenStartYear = int.parse(parts[0]);
        betweenEndYear = int.parse(parts[1]);
        break;
      case CronYearType.NONE:
        break;
    }
  }

  CronYearType _getType(String? value) {
    if (value == null) {
      return CronYearType.NONE;
    }
    if (value.contains('/')) {
      return CronYearType.EVERY_START_AT;
    } else if (value.contains('*')) {
      return CronYearType.EVERY;
    } else if (value.contains('-')) {
      return CronYearType.BETWEEN;
    }

    return CronYearType.SPECIFIC;
  }

  @override
  String toString() {
    switch (type) {
      case CronYearType.EVERY:
        return '*';
      case CronYearType.EVERY_START_AT:
        return '${everyStartYear ?? '*'}/${everyYear ?? '1'}';
      case CronYearType.SPECIFIC:
        return specificYears.isEmpty
            ? currentYear.toString()
            : specificYears.join(',');
      case CronYearType.BETWEEN:
        return '$betweenStartYear-$betweenEndYear';
      case CronYearType.NONE:
        return '';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronYearType.EVERY:
        return '';
      case CronYearType.EVERY_START_AT:
        var year = everyYear ?? 1;
        var startYear = everyStartYear ?? currentYear;
        return year > 1
            ? 'every $year years starting in $startYear'
            : 'starting in $startYear';
      case CronYearType.SPECIFIC:
        var years = specificYears.isEmpty ? [currentYear] : specificYears;
        return years.length == 1
            ? 'in ${years[0]}'
            : 'in ${years.getRange(0, years.length - 2).join(', ')} and ${years.last}';
      case CronYearType.BETWEEN:
        return 'between $betweenStartYear and $betweenEndYear';
      case CronYearType.NONE:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return true;
  }
}
