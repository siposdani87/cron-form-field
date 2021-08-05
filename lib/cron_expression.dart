import 'src/day_of_month.dart';
import 'src/day_of_week.dart';

import 'src/cron_day.dart';
import 'src/cron_hour.dart';
import 'src/cron_minute.dart';
import 'src/cron_month.dart';
import 'src/cron_second.dart';
import 'src/cron_year.dart';

enum CronExpressionType { STANDARD, QUARTZ }

class CronExpression {
  CronExpressionType type;
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
    this.type,
  );

  factory CronExpression.fromString(String cronExpression) {
    List<String> expressionParts = cronExpression.split(' ');
    if (expressionParts.length < 5) {
      expressionParts = '* * ? * *'.split(' ');
    }
    var type = expressionParts.contains('?')
        ? CronExpressionType.QUARTZ
        : CronExpressionType.STANDARD;
    if (expressionParts.length == 5) {
      expressionParts.insert(0, '');
      expressionParts.add('');
    } else if (expressionParts.length == 6) {
      expressionParts.add('');
    }

    return CronExpression(
      CronSecond.fromString(
        expressionParts[0].isEmpty ? null : expressionParts[0],
      ),
      CronMinute.fromString(
        expressionParts[1],
      ),
      CronHour.fromString(
        expressionParts[2],
      ),
      CronDay.fromString(
        expressionParts[3],
        expressionParts[5],
      ),
      CronMonth.fromString(
        expressionParts[4],
      ),
      CronYear.fromString(
        expressionParts[6].isEmpty ? null : expressionParts[6],
      ),
      type,
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
    ]
        .join(' ')
        .trim()
        .replaceFirst('?', type == CronExpressionType.STANDARD ? '*' : '?');
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
