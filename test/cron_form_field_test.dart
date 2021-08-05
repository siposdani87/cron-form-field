import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cron_form_field/cron_form_field.dart';

void main() {
  testWidgets('Testing instantiate CronFormField', (WidgetTester tester) async {
    final cronExpression = '* 5 * ? * *';
    var myWidget = MyWidget(cronExpression: cronExpression);
    await tester.pumpWidget(myWidget);

    expect(
      find.text(cronExpression),
      findsOneWidget,
      reason: 'CronFormField cronExpression not found!',
    );
    var cronFormField = find.byType(CronFormField);
    expect(
      cronFormField,
      findsOneWidget,
      reason: 'CronFormField not found!',
    );
    expect(
      find.text('Schedule'),
      findsOneWidget,
      reason: 'CronFormField Schedule label not found!',
    );

    await tester.tap(cronFormField);
    await tester.pumpAndSettle();

    var panelListTile = find.ancestor(
      of: find.text('Minutes'),
      matching: find.byType(ListTile),
    );
    await tester.tap(panelListTile);
    await tester.pumpAndSettle();

    var buttonLabel = find.text('5');
    expect(
      buttonLabel,
      findsOneWidget,
      reason: 'CronFormField 5 option not displayed on dialog!',
    );
    var button = find.ancestor(
      of: buttonLabel,
      matching: find.byKey(ValueKey('minutes_every_minute_dropdown_button')),
    );
    expect(
      button,
      findsOneWidget,
      reason: 'CronFormField DropdownButton not found!',
    );

    await tester.tap(button);
    await tester.pumpAndSettle();

    var itemLabel = find.text('6').last;
    expect(
      itemLabel,
      findsOneWidget,
      reason: 'CronFormField 6 option not displayed on dialog!',
    );
    var item = find.ancestor(
      of: itemLabel,
      matching: find.byKey(ValueKey('minutes_every_minute_dropdown_menu_item_6')).last,
    );
    expect(
      item,
      findsOneWidget,
      reason: 'CronFormField DropdownMenuItem not found!',
    );

    // await tester.scrollUntilVisible(item, 100.0, scrollable: find.byType(Scrollable).last);
    // await tester.pumpAndSettle();
    // await tester.ensureVisible(item);
    // await tester.pumpAndSettle();
    // await tester.tap(item);
    // await tester.pumpAndSettle();

    var doneLabel = find.text('Done');
    expect(
      doneLabel,
      findsOneWidget,
      reason: 'CronFormField Done button not displayed on dialog!',
    );
    var done = find.ancestor(
      of: doneLabel,
      matching: find.byType(TextButton),
    );

    await tester.tap(done);
    await tester.pumpAndSettle();

    // expect(
    //   find.text(cronExpression),
    //   findsNothing,
    //   reason: 'CronFormField cronExpression found!',
    // );

    // expect(
    //    find.text(cronExpression.replaceFirst('5', '*/6')),
    //    findsOneWidget,
    //    reason: 'CronFormField new cronExpression not found!',
    // );
  });
}

class MyWidget extends StatefulWidget {
  final String cronExpression;

  MyWidget({Key? key, required this.cronExpression}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
