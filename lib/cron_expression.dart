import 'package:cron_form_field/src/day_of_month.dart';
import 'package:cron_form_field/src/day_of_week.dart';
import 'package:cron_form_field/src/cron_day.dart';
import 'package:cron_form_field/src/cron_hour.dart';
import 'package:cron_form_field/src/cron_minute.dart';
import 'package:cron_form_field/src/cron_month.dart';
import 'package:cron_form_field/src/cron_second.dart';
import 'package:cron_form_field/src/cron_year.dart';
import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:cron_form_field/src/enums/cron_expression_type.dart';

export 'package:cron_form_field/src/enums/cron_expression_type.dart';

class CronExpression {
  CronSecond second;
  CronMinute minute;
  CronHour hour;
  CronDay _day;
  CronMonth month;
  CronYear year;
  CronExpressionType type;

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
    var expressionType = expressionParts.contains('?')
        ? CronExpressionType.QUARTZ
        : CronExpressionType.STANDARD;
    if (expressionParts.length == 5) {
      expressionParts.insert(0, '');
      expressionParts.add('');
    } else if (expressionParts.length == 6) {
      expressionParts.add('');
    }

    return CronExpression(
      CronSecond(
        expressionParts[0].isEmpty ? null : expressionParts[0],
      ),
      CronMinute(
        expressionParts[1],
      ),
      CronHour(
        expressionParts[2],
      ),
      CronDay(
        expressionParts[3],
        expressionParts[5],
        expressionType,
      ),
      CronMonth(
        expressionParts[4],
        expressionType,
      ),
      CronYear(
        expressionParts[6].isEmpty ? null : expressionParts[6],
      ),
      expressionType,
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

  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.AUTO);
  }

  String toFormatString(CronExpressionOutputFormat outputFormat) {
    return [
      second.toString(),
      minute.toString(),
      hour.toString(),
      dayOfMonth.toString(),
      month.toFormatString(outputFormat),
      dayOfWeek.toFormatString(outputFormat),
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
