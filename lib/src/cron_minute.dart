import 'package:cron_form_field/src/cron_time_part.dart';
import 'package:cron_form_field/src/util.dart';

/// The minutes part of a cron expression (0-59).
class CronMinute extends CronTimePart {
  CronMinute(String originalValue) : super(originalValue);

  @override
  String get label => 'minute';

  @override
  String get pluralLabel => 'minutes';

  @override
  int get startIndex => 0;

  // Convenience accessors to preserve the existing public API
  int get everyMinute => everyValue;
  int? get everyStartMinute => everyStartValue;
  List<int> get specificMinutes => specificValues;
  int get betweenStartMinute => betweenStartValue;
  int get betweenEndMinute => betweenEndValue;

  void setEveryMinute() => setEvery();

  void setEveryMinuteStartAt(int minute, [int? startMinute]) =>
      setEveryStartAt(minute, startMinute);

  void setSpecificMinutes(List<int> minutes) => setSpecific(minutes);

  void setBetweenMinutes(int startMinute, int endMinute) =>
      setBetween(startMinute, endMinute);

  Map<int, String> getEveryMinuteMap() {
    return rangeListToMap(generateRangeList(1, 60));
  }

  Map<int, String> getMinuteMap() {
    return rangeListToMap(generateRangeList(0, 60), converter: (int num) {
      return num.toString().padLeft(2, '0');
    });
  }
}
