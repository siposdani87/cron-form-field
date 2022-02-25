import 'package:cron_form_field/cron_expression.dart';
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
  CronExpressionType expressionType;

  CronDay(
    this.originalDayOfMonthValue,
    this.originalDayOfWeekValue,
    this.expressionType,
  ) {
    setDefaults();
    _setValue(originalDayOfMonthValue, originalDayOfWeekValue);
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
    dayOfMonth = DayOfMonth(dayOfMonthValue, this);
    dayOfWeek = DayOfWeek(dayOfWeekValue, this);
  }

  bool isDayOfMonth(String value) {
    return (!value.contains('?') &&
            expressionType == CronExpressionType.QUARTZ) ||
        !value.contains('*') && expressionType == CronExpressionType.STANDARD;
  }

  CronDayType _getType(String dayOfMonthValue, String dayOfWeekValue) {
    if (isDayOfMonth(dayOfMonthValue)) {
      return DayOfMonth.getType(dayOfMonthValue);
    }

    return DayOfWeek.getType(dayOfWeekValue);
  }

  @override
  String toReadableString() {
    if (isDayOfMonth(originalDayOfMonthValue)) {
      return dayOfMonth.toReadableString();
    }

    return dayOfWeek.toReadableString();
  }

  @override
  bool validate(String part) {
    if (isDayOfMonth(part)) {
      return dayOfMonth.validate(part);
    }

    return dayOfWeek.validate(part);
  }

  @override
  int get startIndex {
    return 0;
  }
}
