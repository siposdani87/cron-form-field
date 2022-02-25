import 'package:test/test.dart';
import 'package:cron_form_field/cron_expression.dart';

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

    test('Parse at minute 0, at hours and 12, on the 1st day, every 2 months', () {
      var expression = '0 0,12 1 */2 *';
      expect(CronExpression.fromString(expression).toString(), expression);
    });

  },);

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
    },);

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
    },);

    test('Parse every month on the third Thursday of the Month, at noon - 12pm',
        () {
      var expression = '0 0 12 ? * 5#3';
      expect(CronExpression.fromString(expression).toString(), expression);
    },);

    test('Parse every month on the third Monday of the Month at 6am',
          () {
        var expression = '0 0 6 ? * MON#3';
        expect(CronExpression.fromString(expression).toString(), expression);
      },);

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
    },);

    test(
        'Parse every 6 seconds starting at second 09, at minutes :00, :11 and :31, every hour between 04am and 07am, on the nearest weekday to the 27th of the month, every 3 months starting in October, in 2021',
        () {
      var expression = '9/6 0,11,31 4-7 27W 10/3 ? 2021';
      expect(CronExpression.fromString(expression).toString(), expression);
    },);
  });
}
