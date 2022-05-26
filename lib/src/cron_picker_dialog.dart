import 'package:cron_form_field/cron_expression.dart';
import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:flutter/material.dart';

class CronPickerDialog extends StatefulWidget {
  final String value;
  final String? title;
  final String btnDoneText;
  final String btnCancelText;
  final CronExpressionOutputFormat outputFormat;

  const CronPickerDialog({
    Key? key,
    required this.value,
    this.title,
    required this.btnDoneText,
    required this.btnCancelText,
    required this.outputFormat,
  }) : super(key: key);

  @override
  CronPickerDialogState createState() => CronPickerDialogState();
}

enum PanelType { NONE, MINUTES, HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY }

class CronPickerDialogState extends State<CronPickerDialog> {
  late CronExpression _cronExpression;
  PanelType _opened = PanelType.NONE;

  @override
  void initState() {
    super.initState();

    _cronExpression = CronExpression.fromString(widget.value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _dialogTitle(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cronExpressionText(),
            _expansionPanel(
              labelText: 'Minutes',
              panelType: PanelType.MINUTES,
              child: _minutesPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.minute.setEveryMinuteStartAt(1);
              },
            ),
            _expansionPanel(
              labelText: 'Hourly',
              panelType: PanelType.HOURLY,
              child: _hourlyPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.second
                    .setSpecificSeconds([_cronExpression.second.startIndex]);
                _cronExpression.minute
                    .setSpecificMinutes([_cronExpression.minute.startIndex]);
                _cronExpression.hour.setEveryHourStartAt(1);
                _cronExpression.dayOfMonth.setEveryStartAtMonth(1, 1);
              },
            ),
            _expansionPanel(
              labelText: 'Daily',
              panelType: PanelType.DAILY,
              child: _dailyPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.second
                    .setSpecificSeconds([_cronExpression.second.startIndex]);
                _cronExpression.minute
                    .setSpecificMinutes([_cronExpression.minute.startIndex]);
                _cronExpression.hour
                    .setSpecificHours([_cronExpression.hour.startIndex]);
                _cronExpression.dayOfMonth.setEveryStartAtMonth(1, 1);
              },
            ),
            _expansionPanel(
              labelText: 'Weekly',
              panelType: PanelType.WEEKLY,
              child: _weeklyPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.second
                    .setSpecificSeconds([_cronExpression.second.startIndex]);
                _cronExpression.minute
                    .setSpecificMinutes([_cronExpression.minute.startIndex]);
                _cronExpression.hour
                    .setSpecificHours([_cronExpression.hour.startIndex]);
                _cronExpression.dayOfWeek.setSpecificDayOfWeek(
                  [_cronExpression.dayOfWeek.startIndex],
                );
              },
            ),
            _expansionPanel(
              labelText: 'Monthly',
              panelType: PanelType.MONTHLY,
              child: _monthlyPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.second
                    .setSpecificSeconds([_cronExpression.second.startIndex]);
                _cronExpression.minute
                    .setSpecificMinutes([_cronExpression.minute.startIndex]);
                _cronExpression.hour
                    .setSpecificHours([_cronExpression.hour.startIndex]);
                _cronExpression.dayOfWeek
                    .setXthDayOfMonth(_cronExpression.dayOfWeek.startIndex, 1);
                _cronExpression.month.setEveryMonthStartAt(1);
              },
            ),
            _expansionPanel(
              labelText: 'Yearly',
              panelType: PanelType.YEARLY,
              child: _yearlyPanel(),
              onOpen: () {
                _cronExpression.reset();
                _cronExpression.second
                    .setSpecificSeconds([_cronExpression.second.startIndex]);
                _cronExpression.minute
                    .setSpecificMinutes([_cronExpression.minute.startIndex]);
                _cronExpression.hour
                    .setSpecificHours([_cronExpression.hour.startIndex]);
                _cronExpression.dayOfWeek
                    .setXthDayOfMonth(_cronExpression.dayOfWeek.startIndex, 1);
                _cronExpression.month
                    .setSpecificMonths([_cronExpression.month.startIndex]);
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.btnCancelText),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            _cronExpression.toFormatString(widget.outputFormat),
          ),
          child: Text(widget.btnDoneText),
        ),
      ],
    );
  }

  Widget _dialogTitle() {
    return Text(widget.title ?? '');
  }

  Widget _cronExpressionText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Text(
          _cronExpression.toFormatString(widget.outputFormat),
        ),
      ),
    );
  }

  Widget _dropdownButtonFromMap<T, K>(
    String key,
    Map<T, K> map,
    T value,
    void Function(T) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<T>(
        key: Key('${key}_dropdown_button'),
        value: value,
        items: map.entries.map((entry) {
          return DropdownMenuItem<T>(
            key: Key('${key}_dropdown_menu_item_${entry.key}'),
            value: entry.key,
            child: Text(entry.value.toString()),
          );
        }).toList(),
        onChanged: (T? value) {
          if (value == null) {
            return;
          }
          setState(() {
            onChanged(value);
          });
        },
      ),
    );
  }

  Widget _expansionPanel({
    required String labelText,
    required PanelType panelType,
    required Widget child,
    void Function()? onOpen,
  }) {
    return _expandablePanel(
      labelText: labelText,
      opened: _opened == panelType,
      onOpen: () {
        if (onOpen != null) {
          onOpen();
        }
        setState(() {
          _opened = _opened == panelType ? PanelType.NONE : panelType;
        });
      },
      child: child,
    );
  }

  Widget _expandablePanel({
    required String labelText,
    required bool opened,
    required void Function() onOpen,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListTile(
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
            ),
            onTap: onOpen,
            title: Text(labelText),
            selected: opened,
            trailing:
                Icon(opened ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ),
        ),
        Visibility(
          visible: opened,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _minutesPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Every'),
        _dropdownButtonFromMap<int, String>(
          'minutes_every_minute',
          _cronExpression.minute.getEveryMinuteMap(),
          _cronExpression.minute.everyMinute,
          (value) {
            _cronExpression.minute.setEveryMinuteStartAt(
              value,
              _cronExpression.minute.everyStartMinute,
            );
          },
        ),
        const Text('minute(s)'),
      ],
    );
  }

  Widget _hourlyPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Every'),
        _dropdownButtonFromMap<int, String>(
          'hourly_every_hour',
          _cronExpression.hour.getHourMap(),
          _cronExpression.hour.everyHour,
          (value) {
            _cronExpression.hour.setEveryHourStartAt(
              value,
              _cronExpression.hour.everyStartHour,
            );
          },
        ),
        const Text('hour(s) on minute'),
        _dropdownButtonFromMap<int, String>(
          'hourly_specific_minutes',
          _cronExpression.minute.getMinuteMap(),
          _cronExpression.minute.specificMinutes[0],
          (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }

  Widget _dailyPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Every'),
        _dropdownButtonFromMap<int, String>(
          'daily_every_day',
          _cronExpression.dayOfMonth.getDayMap(),
          _cronExpression.dayOfMonth.everyDay,
          (value) {
            _cronExpression.dayOfMonth.setEveryStartAtMonth(
              value,
              _cronExpression.dayOfMonth.everyStartDay,
            );
          },
        ),
        const Text('day(s) at'),
        _dropdownButtonFromMap<int, String>(
          'daily_specific_hours',
          _cronExpression.hour.getHourMap(),
          _cronExpression.hour.specificHours[0],
          (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'daily_specific_minutes',
          _cronExpression.minute.getMinuteMap(),
          _cronExpression.minute.specificMinutes[0],
          (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }

  Widget _weeklyPanel() {
    return Column(
      children: [
        ..._cronExpression.dayOfWeek.getWeekdayMap().entries.map((weekday) {
          return _checkboxListTile(weekday.key, weekday.value);
        }).toList(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('Start time'),
            _dropdownButtonFromMap<int, String>(
              'weekly_specific_hours',
              _cronExpression.hour.getHourMap(),
              _cronExpression.hour.specificHours[0],
              (value) {
                _cronExpression.hour.setSpecificHours([value]);
              },
            ),
            _dropdownButtonFromMap<int, String>(
              'weekly_specific_minutes',
              _cronExpression.minute.getMinuteMap(),
              _cronExpression.minute.specificMinutes[0],
              (value) {
                _cronExpression.minute.setSpecificMinutes([value]);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _monthlyPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('On the'),
        _dropdownButtonFromMap<int, String>(
          'monthly_xth_weeks',
          _cronExpression.dayOfWeek.getWeeksMap(),
          _cronExpression.dayOfWeek.xthWeeks,
          (value) {
            _cronExpression.dayOfWeek.setXthDayOfMonth(
              _cronExpression.dayOfWeek.xthWeekday,
              value,
            );
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'monthly_xth_weekday',
          _cronExpression.dayOfWeek.getWeekdayMap(),
          _cronExpression.dayOfWeek.xthWeekday,
          (value) {
            _cronExpression.dayOfWeek.setXthDayOfMonth(
              value,
              _cronExpression.dayOfWeek.xthWeeks,
            );
          },
        ),
        const Text('of every'),
        _dropdownButtonFromMap<int, String>(
          'monthly_every_month',
          _cronExpression.month.getMonthMap(),
          _cronExpression.month.everyMonth,
          (value) {
            _cronExpression.month.setEveryMonthStartAt(
              value,
              _cronExpression.month.everyStartMonth,
            );
          },
        ),
        const Text('at'),
        _dropdownButtonFromMap<int, String>(
          'monthly_specific_hours',
          _cronExpression.hour.getHourMap(),
          _cronExpression.hour.specificHours[0],
          (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'monthly_specific_minutes',
          _cronExpression.minute.getMinuteMap(),
          _cronExpression.minute.specificMinutes[0],
          (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }

  Widget _yearlyPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('On the'),
        _dropdownButtonFromMap<int, String>(
          'monthly_xth_weeks',
          _cronExpression.dayOfWeek.getWeeksMap(),
          _cronExpression.dayOfWeek.xthWeeks,
          (value) {
            _cronExpression.dayOfWeek.setXthDayOfMonth(
              _cronExpression.dayOfWeek.xthWeekday,
              value,
            );
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'monthly_xth_weekday',
          _cronExpression.dayOfWeek.getWeekdayMap(),
          _cronExpression.dayOfWeek.xthWeekday,
          (value) {
            _cronExpression.dayOfWeek.setXthDayOfMonth(
              value,
              _cronExpression.dayOfWeek.xthWeeks,
            );
          },
        ),
        const Text('of'),
        _dropdownButtonFromMap<int, String>(
          'monthly_every_month',
          _cronExpression.month.getMonthMap(),
          _cronExpression.month.specificMonths[0],
          (value) {
            _cronExpression.month.setSpecificMonths([value]);
          },
        ),
        const Text('at'),
        _dropdownButtonFromMap<int, String>(
          'monthly_specific_hours',
          _cronExpression.hour.getHourMap(),
          _cronExpression.hour.specificHours[0],
          (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'monthly_specific_minutes',
          _cronExpression.minute.getMinuteMap(),
          _cronExpression.minute.specificMinutes[0],
          (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }

  Widget _checkboxListTile(int weekday, String weekdayName) {
    return CheckboxListTile(
      title: Text(weekdayName),
      value: _cronExpression.dayOfWeek.specificWeekdays.contains(weekday),
      onChanged: (bool? value) {
        _cronExpression.dayOfWeek.toggleSpecificWeekday(weekday);
        setState(() {});
      },
    );
  }
}
