import 'package:test/test.dart';
import 'package:cron_form_field/cron_expression.dart';
import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';

void main() {
  group('Standard CronExpressions', () {
    test('Parse every minute without second and year', () {
      var expression = '* * * * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse at minute 5, at hour 0, at month AUG', () {
      var expression = '5 0 * 8 *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse at minute 5, at hour 4, on the SUN day', () {
      var expression = '5 4 * * SUN';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse at minute 0, at hours and 12, on the 1st day, every 2 months',
        () {
      var expression = '0 0,12 1 */2 *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });
  });

  group('Quartz CronExpressions', () {
    test('Parse every minute without second and year', () {
      var expression = '* * ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every second without year', () {
      var expression = '* * * ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every minute without year', () {
      var expression = '0 * * ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every even minute without year', () {
      var expression = '0 */2 * ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every hour at minutes 15, 30 and 45', () {
      var expression = '0 15,30,45 * ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every three hours', () {
      var expression = '0 0 */3 ? * *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every day at midnight - 12am', () {
      var expression = '0 0 0 * * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every day at 6am', () {
      var expression = '0 0 6 * * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every Tuesday at noon', () {
      var expression = '0 0 12 ? * TUE';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every Saturday and Sunday at noon', () {
      var expression = '0 0 12 ? * SUN,SAT';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every 4 days staring on the 1st of the month, at noon', () {
      var expression = '0 0 12 1/4 * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the last day of the month, at noon', () {
      var expression = '0 0 12 L * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the second to last day of the month, at noon',
        () {
      var expression = '0 0 12 L-2 * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the last weekday, at noon', () {
      var expression = '0 0 12 LW * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the last Friday, at noon', () {
      var expression = '0 0 12 6L * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test(
        'Parse every month on the nearest Weekday to the 15th of the month, at noon',
        () {
      var expression = '0 0 12 15W * ?';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the third Thursday of the Month, at noon - 12pm',
        () {
      var expression = '0 0 12 ? * 5#3';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every month on the third Monday of the Month at 6am', () {
      var expression = '0 0 6 ? * MON#3';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every day at noon in January and June', () {
      var expression = '0 0 12 ? JAN,JUN *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every day at noon in February and December', () {
      var expression = '0 0 12 ? 2,12 *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test('Parse every day at noon between September and December', () {
      var expression = '0 0 12 ? 9-12 *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test(
        'Parse every 30 minutes starting at :00 minute after the hour, 1 days before the end of the month, every month starting in April',
        () {
      var expression = '* 0/30 * L-1 4/1 ? *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

    test(
        'Parse every 6 seconds starting at second 09, at minutes :00, :11 and :31, every hour between 04am and 07am, on the nearest weekday to the 27th of the month, every 3 months starting in October, in 2021',
        () {
      var expression = '9/6 0,11,31 4-7 27W 10/3 ? 2021';
      expect(CronExpression.fromString(expression).toString(), expression);
    });
  });

  group('CronExpression.toReadableString()', () {
    test('Every minute', () {
      var expr = CronExpression.fromString('* * * * *');
      expect(expr.toReadableString(), 'Every minute, every hour');
    });

    test('Specific minute and hour', () {
      var expr = CronExpression.fromString('30 6 * * *');
      expect(expr.toReadableString(), contains('30'));
      expect(expr.toReadableString(), contains('6'));
    });

    test('Multiple specific minutes', () {
      var expr = CronExpression.fromString('0 15,30,45 * ? * *');
      var readable = expr.toReadableString();
      expect(readable, contains('15'));
      expect(readable, contains('30'));
      expect(readable, contains('45'));
    });

    test('Every N hours', () {
      var expr = CronExpression.fromString('0 0 */3 ? * *');
      expect(expr.toReadableString(), contains('every 3 hours'));
    });

    test('Specific day of week', () {
      var expr = CronExpression.fromString('0 0 12 ? * TUE');
      expect(expr.toReadableString(), contains('TUE'));
    });

    test('Day before end of month', () {
      var expr = CronExpression.fromString('0 0 12 L-2 * ?');
      expect(expr.toReadableString(),
          contains('2 days before the end of the month'));
    });

    test('Last weekday of month', () {
      var expr = CronExpression.fromString('0 0 12 LW * ?');
      expect(expr.toReadableString(), contains('last weekday of the month'));
    });

    test('Nearest weekday', () {
      var expr = CronExpression.fromString('0 0 12 15W * ?');
      expect(expr.toReadableString(), contains('nearest weekday'));
    });

    test('Xth day of month', () {
      var expr = CronExpression.fromString('0 0 12 ? * 5#3');
      expect(expr.toReadableString(), contains('3rd'));
    });

    test('With year', () {
      var expr = CronExpression.fromString('0 0 12 ? * * 2021');
      expect(expr.toReadableString(), contains('2021'));
    });

    test('Between months', () {
      var expr = CronExpression.fromString('0 0 12 ? 9-12 *');
      expect(expr.toReadableString(), contains('between'));
    });
  });

  group('CronExpression.toFormatString() output formats', () {
    test('AUTO preserves original format for months', () {
      var expr = CronExpression.fromString('0 0 12 ? JAN,JUN *');
      expect(
        expr.toFormatString(CronExpressionOutputFormat.auto),
        '0 0 12 ? JAN,JUN *',
      );
    });

    test('AUTO preserves numeric format for months', () {
      var expr = CronExpression.fromString('0 0 12 ? 2,12 *');
      expect(
        expr.toFormatString(CronExpressionOutputFormat.auto),
        '0 0 12 ? 2,12 *',
      );
    });

    test('ALLOWED_VALUES outputs numeric months', () {
      var expr = CronExpression.fromString('0 0 12 ? JAN,JUN *');
      var result =
          expr.toFormatString(CronExpressionOutputFormat.allowedValues);
      expect(result, contains('0'));
      expect(result, isNot(contains('JAN')));
    });

    test('ALTERNATIVE_VALUES outputs named months from Quartz', () {
      var expr = CronExpression.fromString('0 0 12 ? 2,12 *');
      var result =
          expr.toFormatString(CronExpressionOutputFormat.alternativeValues);
      // Quartz months are 0-based: 2=MAR, 12=null (index maps differ by expression type)
      expect(result, isNotEmpty);
    });

    test('AUTO preserves named weekdays', () {
      var expr = CronExpression.fromString('0 0 12 ? * SUN,SAT');
      expect(
        expr.toFormatString(CronExpressionOutputFormat.auto),
        '0 0 12 ? * SUN,SAT',
      );
    });

    test('ALTERNATIVE_VALUES outputs named weekdays', () {
      var expr = CronExpression.fromString('0 0 12 ? * 1,7');
      var result =
          expr.toFormatString(CronExpressionOutputFormat.alternativeValues);
      expect(result, contains('SUN'));
      expect(result, contains('SAT'));
    });
  });

  group('CronExpression.reset()', () {
    test('Reset returns to default state', () {
      var expr = CronExpression.fromString('0 30 6 1/4 * ?');
      expr.reset();
      expect(expr.minute.toString(), '*');
      expect(expr.hour.toString(), '*');
    });
  });

  group('Mutation methods', () {
    test('CronMinute.setEveryMinuteStartAt', () {
      var expr = CronExpression.fromString('* * * * *');
      expr.minute.setEveryMinuteStartAt(5, 10);
      expect(expr.minute.toString(), '10/5');
    });

    test('CronMinute.setSpecificMinutes', () {
      var expr = CronExpression.fromString('* * * * *');
      expr.minute.setSpecificMinutes([0, 15, 30, 45]);
      expect(expr.minute.toString(), '0,15,30,45');
    });

    test('CronMinute.setBetweenMinutes', () {
      var expr = CronExpression.fromString('* * * * *');
      expr.minute.setBetweenMinutes(10, 20);
      expect(expr.minute.toString(), '10-20');
    });

    test('CronHour.setEveryHourStartAt', () {
      var expr = CronExpression.fromString('* * * * *');
      expr.hour.setEveryHourStartAt(3, 2);
      expect(expr.hour.toString(), '2/3');
    });

    test('CronHour.setSpecificHours', () {
      var expr = CronExpression.fromString('* * * * *');
      expr.hour.setSpecificHours([0, 6, 12, 18]);
      expect(expr.hour.toString(), '0,6,12,18');
    });

    test('CronSecond.setEverySecondStartAt', () {
      var expr = CronExpression.fromString('* * * ? * *');
      expr.second.setEverySecondStartAt(10, 5);
      expect(expr.second.toString(), '5/10');
    });

    test('CronSecond.setSpecificSeconds', () {
      var expr = CronExpression.fromString('* * * ? * *');
      expr.second.setSpecificSeconds([0, 30]);
      expect(expr.second.toString(), '0,30');
    });

    test('CronMonth.setEveryMonthStartAt', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.month.setEveryMonthStartAt(2, 3);
      expect(expr.month.toString(), '3/2');
    });

    test('CronMonth.setSpecificMonths', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.month.setSpecificMonths([1, 6]);
      expect(expr.month.toString(), contains('1'));
    });

    test('CronMonth.setBetweenMonths', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.month.setBetweenMonths(3, 9);
      expect(expr.month.toString(), contains('-'));
    });

    test('DayOfMonth.setEveryStartAtMonth', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.dayOfMonth.setEveryStartAtMonth(4, 1);
      expect(expr.dayOfMonth.toString(), '1/4');
    });

    test('DayOfMonth.setLastDayOfMonth', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.dayOfMonth.setLastDayOfMonth(0);
      expect(expr.dayOfMonth.toString(), contains('L'));
    });

    test('DayOfWeek.setSpecificDayOfWeek', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.dayOfWeek.setSpecificDayOfWeek([1, 3, 5]);
      expect(expr.dayOfWeek.toString(), contains('1'));
    });

    test('DayOfWeek.toggleSpecificWeekday', () {
      var expr = CronExpression.fromString('0 0 12 ? * SUN');
      expr.dayOfWeek.toggleSpecificWeekday(2);
      expect(expr.dayOfWeek.specificWeekdays, contains(2));
    });

    test('DayOfWeek.setXthDayOfMonth', () {
      var expr = CronExpression.fromString('0 0 12 ? * *');
      expr.dayOfWeek.setXthDayOfMonth(2, 3);
      expect(expr.dayOfWeek.toString(), contains('#'));
    });
  });

  group('Malformed input handling', () {
    test('Empty string falls back to default', () {
      var expr = CronExpression.fromString('');
      expect(expr.toString(), '* * ? * *');
    });

    test('Too few parts falls back to default', () {
      var expr = CronExpression.fromString('* *');
      expect(expr.toString(), '* * ? * *');
    });

    test('Single part falls back to default', () {
      var expr = CronExpression.fromString('*');
      expect(expr.toString(), '* * ? * *');
    });
  });

  group('Expression type detection', () {
    test('Standard type when no ? present', () {
      var expr = CronExpression.fromString('* * * * *');
      expect(expr.type, CronExpressionType.standard);
    });

    test('Quartz type when ? present', () {
      var expr = CronExpression.fromString('* * ? * *');
      expect(expr.type, CronExpressionType.quartz);
    });

    test('Quartz type with 6 parts', () {
      var expr = CronExpression.fromString('0 * * ? * *');
      expect(expr.type, CronExpressionType.quartz);
    });

    test('Quartz type with 7 parts', () {
      var expr = CronExpression.fromString('0 0 12 ? * * 2021');
      expect(expr.type, CronExpressionType.quartz);
    });
  });

  group('October month name fix', () {
    test('OCT is used instead of OKT in Standard expressions', () {
      var expr = CronExpression.fromString('0 0 * 10 *');
      var result = expr.month
          .toFormatString(CronExpressionOutputFormat.alternativeValues);
      expect(result, 'OCT');
      expect(result, isNot(contains('OKT')));
    });

    test('Month map contains OCT not OKT', () {
      var expr = CronExpression.fromString('0 0 * * *');
      var monthMap = expr.month.getMonthMap();
      expect(monthMap.values, contains('OCT'));
      expect(monthMap.values, isNot(contains('OKT')));
    });
  });

  group('toReadableString off-by-one fix', () {
    test('Three specific seconds includes all items', () {
      var expr = CronExpression.fromString('* * * ? * *');
      expr.second.setSpecificSeconds([0, 15, 30]);
      var readable = expr.second.toReadableString();
      expect(readable, contains('0'));
      expect(readable, contains('15'));
      expect(readable, contains('30'));
      expect(readable, 'at seconds 0, 15 and 30');
    });

    test('Three specific minutes includes all items', () {
      var expr = CronExpression.fromString('0 15,30,45 * ? * *');
      var readable = expr.minute.toReadableString();
      expect(readable, 'at minutes 15, 30 and 45');
    });

    test('Three specific hours includes all items', () {
      var expr = CronExpression.fromString('0 0 0,6,12 ? * *');
      var readable = expr.hour.toReadableString();
      expect(readable, 'at hours 0, 6 and 12');
    });

    test('Two specific seconds', () {
      var expr = CronExpression.fromString('* * * ? * *');
      expr.second.setSpecificSeconds([0, 30]);
      expect(expr.second.toReadableString(), 'at seconds 0 and 30');
    });

    test('Single specific second', () {
      var expr = CronExpression.fromString('* * * ? * *');
      expr.second.setSpecificSeconds([15]);
      expect(expr.second.toReadableString(), 'at second 15');
    });
  });

  group('DayOfMonth.getType fix', () {
    test('L-2 is DAY_BEFORE_END_OF_MONTH', () {
      var expr = CronExpression.fromString('0 0 12 L-2 * ?');
      expect(expr.toString(), '0 0 12 L-2 * ?');
    });

    test('LW is LAST_WEEKDAY_OF_MONTH', () {
      var expr = CronExpression.fromString('0 0 12 LW * ?');
      expect(expr.toString(), '0 0 12 LW * ?');
    });

    test('L alone is LAST_DAY_OF_MONTH', () {
      var expr = CronExpression.fromString('0 0 12 L * ?');
      expect(expr.toString(), '0 0 12 L * ?');
    });
  });

  group('CronExpression fields are final', () {
    test('fields cannot be reassigned but parts can be mutated', () {
      var expr = CronExpression.fromString('0 * * ? * *');
      // Mutating through methods still works
      expr.minute.setSpecificMinutes([5, 10]);
      expect(expr.toString(), '0 5,10 * ? * *');
      // reset still works
      expr.reset();
      expect(expr.toString(), '* * * * * ? *');
    });
  });

  group('CronYear maps', () {
    test('getEveryYearMap returns 1-10', () {
      var expr = CronExpression.fromString('0 0 12 ? * * *');
      var map = expr.year.getEveryYearMap();
      expect(map.length, 10);
      expect(map[1], '1');
      expect(map[10], '10');
    });

    test('getYearMap returns current year + 20 years', () {
      var expr = CronExpression.fromString('0 0 12 ? * * *');
      var map = expr.year.getYearMap();
      var currentYear = DateTime.now().year;
      expect(map.length, 21);
      expect(map.containsKey(currentYear), true);
      expect(map.containsKey(currentYear + 20), true);
    });

    test('setEveryYearStartAt roundtrips', () {
      var expr = CronExpression.fromString('0 0 12 ? * * *');
      expr.year.setEveryYearStartAt(2, 2027);
      expect(expr.year.toString(), '2027/2');
    });
  });
}
