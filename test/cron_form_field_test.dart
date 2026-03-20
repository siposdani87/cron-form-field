import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cron_form_field/cron_form_field.dart';

void main() {
  group('CronFormField widget', () {
    testWidgets('renders with initial value and label',
        (WidgetTester tester) async {
      const cronExpression = '* 5 * ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      expect(
        find.text(cronExpression),
        findsOneWidget,
        reason: 'CronFormField should display the initial cron expression',
      );
      expect(
        find.byType(CronFormField),
        findsOneWidget,
        reason: 'CronFormField widget should be present',
      );
      expect(
        find.text('Schedule'),
        findsOneWidget,
        reason: 'CronFormField should display the label text',
      );
    });

    testWidgets('opens dialog on tap', (WidgetTester tester) async {
      const cronExpression = '* 5 * ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      expect(
        find.text('Done'),
        findsOneWidget,
        reason: 'Dialog Done button should be visible',
      );
      expect(
        find.text('Cancel'),
        findsOneWidget,
        reason: 'Dialog Cancel button should be visible',
      );
      expect(
        find.text('Minutes'),
        findsOneWidget,
        reason: 'Minutes panel should be visible in dialog',
      );
      expect(
        find.text('Hourly'),
        findsOneWidget,
        reason: 'Hourly panel should be visible in dialog',
      );
      expect(
        find.text('Daily'),
        findsOneWidget,
        reason: 'Daily panel should be visible in dialog',
      );
      expect(
        find.text('Weekly'),
        findsOneWidget,
        reason: 'Weekly panel should be visible in dialog',
      );
      expect(
        find.text('Monthly'),
        findsOneWidget,
        reason: 'Monthly panel should be visible in dialog',
      );
      expect(
        find.text('Yearly'),
        findsOneWidget,
        reason: 'Yearly panel should be visible in dialog',
      );
    });

    testWidgets('cancel button closes dialog without changing value',
        (WidgetTester tester) async {
      const cronExpression = '* 5 * ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(
        find.text('Done'),
        findsNothing,
        reason: 'Dialog should be closed after Cancel',
      );
      expect(
        find.text(cronExpression),
        findsOneWidget,
        reason: 'Original value should be preserved after Cancel',
      );
    });

    testWidgets('done button closes dialog', (WidgetTester tester) async {
      const cronExpression = '* 5 * ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(
        find.text('Done'),
        findsNothing,
        reason: 'Dialog should be closed after Done',
      );
    });

    testWidgets('opening Minutes panel shows minute controls',
        (WidgetTester tester) async {
      const cronExpression = '* 5 * ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      var panelListTile = find.ancestor(
        of: find.text('Minutes'),
        matching: find.byType(ListTile),
      );
      await tester.tap(panelListTile);
      await tester.pumpAndSettle();

      expect(
        find.text('Every'),
        findsOneWidget,
        reason: 'Minutes panel should show "Every" label',
      );
      expect(
        find.text('minute(s)'),
        findsOneWidget,
        reason: 'Minutes panel should show "minute(s)" label',
      );
      expect(
        find.byKey(const ValueKey('minutes_every_minute_dropdown_button')),
        findsOneWidget,
        reason: 'Minutes dropdown should be present',
      );
    });

    testWidgets('opening Hourly panel shows hour controls',
        (WidgetTester tester) async {
      const cronExpression = '0 0 */3 ? * *';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      var panelListTile = find.ancestor(
        of: find.text('Hourly'),
        matching: find.byType(ListTile),
      );
      await tester.tap(panelListTile);
      await tester.pumpAndSettle();

      expect(
        find.text('hour(s) on minute'),
        findsOneWidget,
        reason: 'Hourly panel should show hour/minute labels',
      );
    });

    testWidgets('opening Weekly panel shows weekday checkboxes',
        (WidgetTester tester) async {
      const cronExpression = '0 0 12 ? * TUE';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      var panelListTile = find.ancestor(
        of: find.text('Weekly'),
        matching: find.byType(ListTile),
      );
      await tester.tap(panelListTile);
      await tester.pumpAndSettle();

      expect(
        find.byType(CheckboxListTile),
        findsNWidgets(7),
        reason: 'Weekly panel should show 7 weekday checkboxes',
      );
      expect(
        find.text('Start time'),
        findsOneWidget,
        reason: 'Weekly panel should show start time label',
      );
    });

    testWidgets('dialog shows readable description',
        (WidgetTester tester) async {
      const cronExpression = '0 0 12 ? * TUE';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      expect(
        find.text(cronExpression),
        findsWidgets,
        reason: 'Dialog should show the cron expression string',
      );
    });

    testWidgets('done after opening panel returns new value',
        (WidgetTester tester) async {
      const cronExpression = '0 0 12 ? * TUE';
      await tester.pumpWidget(const MyWidget(cronExpression: cronExpression));

      await tester.tap(find.byType(CronFormField));
      await tester.pumpAndSettle();

      var panelListTile = find.ancestor(
        of: find.text('Minutes'),
        matching: find.byType(ListTile),
      );
      await tester.tap(panelListTile);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(
        find.text(cronExpression),
        findsNothing,
        reason:
            'Original expression should be replaced after opening a panel and pressing Done',
      );
    });
  });
}

class MyWidget extends StatefulWidget {
  final String cronExpression;

  const MyWidget({super.key, required this.cronExpression});

  @override
  MyWidgetState createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  late String _value;

  @override
  void initState() {
    super.initState();

    _value = widget.cronExpression;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            CronFormField(
              initialValue: _value,
              labelText: 'Schedule',
              onChanged: (val) => setState(() => _value = val),
            ),
          ],
        ),
      ),
    );
  }
}
