import 'src/day_of_month.dart';
import 'src/day_of_week.dart';

import 'src/cron_day.dart';
import 'src/cron_hour.dart';
import 'src/cron_minute.dart';
import 'src/cron_month.dart';
import 'src/cron_second.dart';
import 'src/cron_year.dart';

class CronExpression {
  CronSecond second;
  CronMinute minute;
  CronHour hour;
  CronDay _day;
  CronMonth month;
  CronYear year;

  CronExpression(
    this.second,
    this.minute,
    this.hour,
    this._day,
    this.month,
    this.year,
  );

  factory CronExpression.fromString(String cronExpression) {
    List<String> expressionParts = cronExpression.split(' ');
    if (expressionParts.length < 5) {
      expressionParts = '* * ? * *'.split(' ');
    }
    int offset = expressionParts.length == 5 ? 0 : 1;

    return CronExpression(
      CronSecond.fromString(
        offset == 0 ? null : expressionParts[0],
      ),
      CronMinute.fromString(
        expressionParts[offset + 0],
      ),
      CronHour.fromString(
        expressionParts[offset + 1],
      ),
      CronDay.fromString(
        expressionParts[offset + 2],
        expressionParts[offset + 4],
      ),
      CronMonth.fromString(
        expressionParts[offset + 3],
      ),
      CronYear.fromString(
        expressionParts.length == 7 ? expressionParts[6] : null,
      ),
    );
  }

  DayOfMonth get dayOfMonth => _day.dayOfMonth;

  DayOfWeek get dayOfWeek => _day.dayOfWeek;

  void reset() {
    second.reset();
    minute.reset();
    hour.reset();
    _day.reset();
    month.reset();
    year.reset();
  }

  String toString() {
    return [
      second.toString(),
      minute.toString(),
      hour.toString(),
      dayOfMonth.toString(),
      month.toString(),
      dayOfWeek.toString(),
      year.toString(),
    ].join(' ').trim();
  }

  String toReadableString() {
    final pattern = RegExp('\\s+');
    var sentence = [
      second.toReadableString(),
      minute.toReadableString(),
      hour.toReadableString(),
      _day.toReadableString(),
      month.toReadableString(),
      year.toReadableString(),
    ]
        .where((element) => element.isNotEmpty)
        .toList()
        .join(', ')
        .replaceAll(pattern, ' ')
        .trim();

    return _capitalize(sentence);
  }

  String _capitalize(String str) {
    if (str.isEmpty) {
      return '';
    }

    return '${str[0].toUpperCase()}${str.substring(1)}';
  }
}
