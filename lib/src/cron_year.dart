
import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/enums/cron_year_type.dart';

class CronYear implements CronPart {
  late CronYearType type;
  late int? everyYear;
  late int? everyStartYear;
  late List<int> specificYears;
  late int betweenStartYear;
  late int betweenEndYear;
  late int currentYear;

  CronYear(String? originalValue) {
    currentYear = DateTime.now().year;
    setDefaults();
    _setValue(originalValue);
  }

  @override
  void setDefaults() {
    // 2021
    everyYear = null;
    everyStartYear = null;
    specificYears = [startIndex];
    betweenStartYear = startIndex;
    betweenEndYear = startIndex;
  }

  @override
  void reset() {
    type = CronYearType.every;
    setDefaults();
  }

  void setEveryYear() {
    type = CronYearType.every;
  }

  void setEveryYearStartAt(int? year, [int? startYear]) {
    type = CronYearType.everyStartAt;
    everyYear = year;
    everyStartYear = startYear;
  }

  void setSpecificYears(List<int> years) {
    type = CronYearType.specific;
    specificYears = years;
  }

  void setBetweenYears(int startYear, int endYear) {
    type = CronYearType.between;
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
      case CronYearType.every:
        break;
      case CronYearType.everyStartAt:
        var parts = value.split('/');
        everyStartYear = parts[0] == '*' ? null : int.parse(parts[0]);
        everyYear = parts[1] == '*' ? null : int.parse(parts[1]);
        break;
      case CronYearType.specific:
        specificYears = value.split(',').map((v) => int.parse(v)).toList();
        break;
      case CronYearType.between:
        var parts = value.split('-');
        betweenStartYear = int.parse(parts[0]);
        betweenEndYear = int.parse(parts[1]);
        break;
      case CronYearType.none:
        break;
    }
  }

  CronYearType _getType(String? value) {
    if (value == null) {
      return CronYearType.none;
    }
    if (value.contains('/')) {
      return CronYearType.everyStartAt;
    } else if (value.contains('*')) {
      return CronYearType.every;
    } else if (value.contains('-')) {
      return CronYearType.between;
    }

    return CronYearType.specific;
  }

  @override
  String toString() {
    switch (type) {
      case CronYearType.every:
        return '*';
      case CronYearType.everyStartAt:
        return '${everyStartYear ?? '*'}/${everyYear ?? '1'}';
      case CronYearType.specific:
        return specificYears.isEmpty
            ? startIndex.toString()
            : specificYears.join(',');
      case CronYearType.between:
        return '$betweenStartYear-$betweenEndYear';
      case CronYearType.none:
        return '';
    }
  }

  @override
  String toReadableString() {
    switch (type) {
      case CronYearType.every:
        return '';
      case CronYearType.everyStartAt:
        var year = everyYear ?? 1;
        var startYear = everyStartYear ?? startIndex;
        return year > 1
            ? 'every $year years starting in $startYear'
            : 'starting in $startYear';
      case CronYearType.specific:
        var years = specificYears.isEmpty ? [startIndex] : specificYears;
        return years.length == 1
            ? 'in ${years[0]}'
            : 'in ${years.getRange(0, years.length - 1).join(', ')} and ${years.last}';
      case CronYearType.between:
        return 'between $betweenStartYear and $betweenEndYear';
      case CronYearType.none:
        return '';
    }
  }

  @override
  bool validate(String part) {
    return RegExp(r'^(\*|(\*|[0-9]{4})/([0-9]{1,4}|\*)|[0-9]{4}(-[0-9]{4}|)(,[0-9]{4})*)$')
        .hasMatch(part);
  }

  @override
  int get startIndex {
    return currentYear;
  }
}
