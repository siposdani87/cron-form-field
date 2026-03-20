import 'package:cron_form_field/src/cron_time_part.dart';
import 'package:cron_form_field/src/util.dart';

/// The seconds part of a cron expression (0-59). Optional in Standard format.
class CronSecond extends CronTimePart {
  CronSecond(String? originalValue) : super(originalValue);

  @override
  String get label => 'second';

  @override
  String get pluralLabel => 'seconds';

  @override
  bool get supportsNone => true;

  @override
  int get startIndex => 0;

  // Convenience accessors to preserve the existing public API
  int get everySecond => everyValue;
  int? get everyStartSecond => everyStartValue;
  List<int> get specificSeconds => specificValues;
  int get betweenStartSecond => betweenStartValue;
  int get betweenEndSecond => betweenEndValue;

  void setEverySecond() => setEvery();

  void setEverySecondStartAt(int second, [int? startSecond]) =>
      setEveryStartAt(second, startSecond);

  void setSpecificSeconds(List<int> seconds) => setSpecific(seconds);

  void setBetweenSeconds(int startSecond, int endSecond) =>
      setBetween(startSecond, endSecond);

  Map<int, String> getEverySecondMap() {
    return rangeListToMap(generateRangeList(1, 60));
  }

  Map<int, String> getSecondMap() {
    return rangeListToMap(generateRangeList(0, 60), converter: (int num) {
      return num.toString().padLeft(2, '0');
    });
  }
}
