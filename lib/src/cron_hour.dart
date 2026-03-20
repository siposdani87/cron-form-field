import 'package:cron_form_field/src/cron_time_part.dart';
import 'package:cron_form_field/src/util.dart';

/// The hours part of a cron expression (0-23).
class CronHour extends CronTimePart {
  CronHour(String originalValue) : super(originalValue);

  @override
  String get label => 'hour';

  @override
  String get pluralLabel => 'hours';

  @override
  int get startIndex => 0;

  // Convenience accessors to preserve the existing public API
  int get everyHour => everyValue;
  int? get everyStartHour => everyStartValue;
  List<int> get specificHours => specificValues;
  int get betweenStartHour => betweenStartValue;
  int get betweenEndHour => betweenEndValue;

  void setEveryHour() => setEvery();

  void setEveryHourStartAt(int hour, [int? startHour]) =>
      setEveryStartAt(hour, startHour);

  void setSpecificHours(List<int> hours) => setSpecific(hours);

  void setBetweenHours(int startHour, int endHour) =>
      setBetween(startHour, endHour);

  Map<int, String> getHourMap() {
    return rangeListToMap(generateRangeList(0, 24), converter: (int num) {
      return num.toString().padLeft(2, '0');
    });
  }
}
