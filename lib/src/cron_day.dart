import 'cron_day_type.dart';
import 'cron_part.dart';
import 'day_of_month.dart';
import 'day_of_week.dart';

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

  void setDefaults() {
    // empty block
  }

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

  String toReadableString() {
    if (!originalDayOfMonthValue.contains('?')) {
      return dayOfMonth.toReadableString();
    }

    return dayOfWeek.toReadableString();
  }
}
