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

/// Represents a parsed cron expression with individual part accessors.
///
/// Supports both Standard (5-part) and Quartz (6-7 part) cron formats.
///
/// ```dart
/// final expr = CronExpression.fromString('0 30 9 ? * MON-FRI');
/// print(expr.toReadableString()); // Human-readable description
/// print(expr.toString());         // Back to cron string
/// ```
class CronExpression {
  /// The seconds part (Quartz only, empty for Standard).
  final CronSecond second;

  /// The minutes part (0-59).
  final CronMinute minute;

  /// The hours part (0-23).
  final CronHour hour;

  final CronDay _day;

  /// The month part (1-12 or JAN-DEC).
  final CronMonth month;

  /// The year part (Quartz only, empty for Standard).
  final CronYear year;

  /// Whether this is a [CronExpressionType.standard] or
  /// [CronExpressionType.quartz] expression.
  final CronExpressionType type;

  CronExpression(
    this.second,
    this.minute,
    this.hour,
    this._day,
    this.month,
    this.year,
    this.type,
  );

  /// Parses a cron expression string into a [CronExpression].
  ///
  /// Accepts 5-part (Standard), 6-part, or 7-part (Quartz) expressions.
  /// If fewer than 5 parts are provided, falls back to `* * ? * *`.
  factory CronExpression.fromString(String cronExpression) {
    List<String> expressionParts = cronExpression.split(' ');
    if (expressionParts.length < 5) {
      expressionParts = '* * ? * *'.split(' ');
    }
    var expressionType = expressionParts.contains('?')
        ? CronExpressionType.quartz
        : CronExpressionType.standard;
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

  /// The day-of-month part (1-31, or special values like L, W).
  DayOfMonth get dayOfMonth => _day.dayOfMonth;

  /// The day-of-week part (0-6 or SUN-SAT, or special values like #, L).
  DayOfWeek get dayOfWeek => _day.dayOfWeek;

  /// Resets all parts to their default wildcard values.
  void reset() {
    second.reset();
    minute.reset();
    hour.reset();
    _day.reset();
    month.reset();
    year.reset();
  }

  /// Returns the cron expression as a string using [CronExpressionOutputFormat.auto].
  @override
  String toString() {
    return toFormatString(CronExpressionOutputFormat.auto);
  }

  /// Returns the cron expression as a string using the specified [outputFormat].
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
        .replaceFirst('?', type == CronExpressionType.standard ? '*' : '?');
  }

  /// Returns a human-readable description of the cron expression.
  ///
  /// Example: `'At minute 30, at hour 9, on the MON, TUE, WED, THU and FRI day'`
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
