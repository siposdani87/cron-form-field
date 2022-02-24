import 'package:cron_form_field/src/enums/cron_day_type.dart';
import 'package:cron_form_field/src/cron_part.dart';
import 'package:cron_form_field/src/day_of_month.dart';
import 'package:cron_form_field/src/day_of_week.dart';

class CronDay implements CronPart {
  String originalDayOfMonthValue;
  String originalDayOfWeekValue;
  late DayOfMonth dayOfMonth;
  late DayOfWeek dayOfWeek;
  late CronDayType type;

  CronDay(this.originalDayOfMonthValue, this.originalDayOfWeekValue) {
    setDefaults();
    _setValue(originalDayOfMonthValue, originalDayOfWeekValue);
  }

  factory CronDay.fromString(
    String dayOfMonthExpression,
    String dayOfWeekExpression,
  ) {
    return CronDay(dayOfMonthExpression, dayOfWeekExpression);
  }

  @override
  void setDefaults() {
    // empty block
  }

  @override
  void reset() {
    type = CronDayType.EVERY_MONTH;
    setDefaults();
    dayOfMonth.setDefaults();
    dayOfWeek.setDefaults();
  }

  void _setValue(String dayOfMonthValue, String dayOfWeekValue) {
    type = _getType(dayOfMonthValue, dayOfWeekValue);
    dayOfMonth = DayOfMonth.fromString(dayOfMonthValue, this);
    dayOfWeek = DayOfWeek.fromString(dayOfWeekValue, this);
  }

  CronDayType _getType(String dayOfMonthValue, String dayOfWeekValue) {
    if (!dayOfMonthValue.contains('?')) {
      return DayOfMonth.getType(dayOfMonthValue);
    }

    return DayOfWeek.getType(dayOfWeekValue);
  }

  @override
  String toReadableString() {
    if (!originalDayOfMonthValue.contains('?')) {
      return dayOfMonth.toReadableString();
    }

    return dayOfWeek.toReadableString();
  }

  @override
  bool validate(String part) {
    if (!part.contains('?')) {
      return dayOfMonth.validate(part);
    }

    return dayOfWeek.validate(part);
  }
}
