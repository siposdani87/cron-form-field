import '../cron_expression.dart';
import 'package:flutter/material.dart';

class CronPickerDialog extends StatefulWidget {
  final String value;
  final String? title;
  final String btnDoneText;
  final String btnCancelText;

  CronPickerDialog(
    this.value,
    this.title,
    this.btnDoneText,
    this.btnCancelText,
  );

  @override
  _CronPickerDialogState createState() => new _CronPickerDialogState();
}

enum PanelType { NONE, MINUTES, HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY }

class _CronPickerDialogState extends State<CronPickerDialog> {
  late CronExpression _cronExpression;
  PanelType _opened = PanelType.NONE;

  @override
  void initState() {
    super.initState();

    _cronExpression = new CronExpression.fromString(widget.value);
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
                    _cronExpression.minute.setEveryMinuteStartAt(1, null);
                  },
                ),
                _expansionPanel(
                  labelText: 'Hourly',
                  panelType: PanelType.HOURLY,
                  child: _hourlyPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setSpecificSeconds([0]);
                    _cronExpression.minute.setSpecificMinutes([0]);
                    _cronExpression.hour.setEveryHourStartAt(1, null);
                    _cronExpression.dayOfMonth.setEveryStartAtMonth(1, 1);
                  },
                ),
                _expansionPanel(
                  labelText: 'Daily',
                  panelType: PanelType.DAILY,
                  child: _dailyPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setSpecificSeconds([0]);
                    _cronExpression.minute.setSpecificMinutes([0]);
                    _cronExpression.hour.setSpecificHours([0]);
                    _cronExpression.dayOfMonth.setEveryStartAtMonth(1, 1);
                  },
                ),
                _expansionPanel(
                  labelText: 'Weekly',
                  panelType: PanelType.WEEKLY,
                  child: _weeklyPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setSpecificSeconds([0]);
                    _cronExpression.minute.setSpecificMinutes([0]);
                    _cronExpression.hour.setSpecificHours([0]);
                    _cronExpression.dayOfWeek.setSpecificDayOfWeek(['SUN']);
                  },
                ),
                _expansionPanel(
                  labelText: 'Monthly',
                  panelType: PanelType.MONTHLY,
                  child: _monthlyPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setSpecificSeconds([0]);
                    _cronExpression.minute.setSpecificMinutes([0]);
                    _cronExpression.hour.setSpecificHours([0]);
                    _cronExpression.dayOfWeek.setXthDayOfMonth(0, 1);
                    _cronExpression.month.setEveryMonthStartAt(1, null);
                  },
                ),
                _expansionPanel(
                  labelText: 'Yearly',
                  panelType: PanelType.YEARLY,
                  child: _yearlyPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setSpecificSeconds([0]);
                    _cronExpression.minute.setSpecificMinutes([0]);
                    _cronExpression.hour.setSpecificHours([0]);
                    _cronExpression.dayOfWeek.setXthDayOfMonth(0, 1);
                    _cronExpression.month.setSpecificMonths(['JAN']);
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
            _cronExpression.toString(),
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
        padding: EdgeInsets.only(bottom: 15.0),
        child: Text(_cronExpression.toString()),
      ),
    );
  }

  Widget _dropdownButtonFromList<T>(
    String key,
    List<T> items,
    T? value,
    void Function(T) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<T>(
        key: Key('${key}_dropdown_button'),
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<T>(
            key: Key('${key}_dropdown_menu_item_$item'),
            child: Text(item.toString()),
            value: item,
          );
        }).toList(),
        onChanged: (T? value) {
          setState(() {
            onChanged(value!);
          });
        },
      ),
    );
  }

  Widget _dropdownButtonFromMap<T, K>(
      String key,
      Map<T, K> map,
      T? value,
      void Function(T) onChanged,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton<T>(
        key: Key('${key}_dropdown_button'),
        value: value,
        items: map.entries.map((entry) {
          return DropdownMenuItem<T>(
            key: Key('${key}_dropdown_menu_item_${entry.key}'),
            child: Text(entry.value.toString()),
            value: entry.key,
          );
        }).toList(),
        onChanged: (T? value) {
          setState(() {
            onChanged(value!);
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
          padding: EdgeInsets.only(top: 10.0),
          child: ListTile(
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
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
            padding: EdgeInsets.symmetric(horizontal: 15.0),
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
        Text('Every'),
        _dropdownButtonFromList<int>(
          'minutes_every_minute',
          _cronExpression.minute.getEveryMinuteList(),
          _cronExpression.minute.everyMinute,
          (value) {
            _cronExpression.minute.setEveryMinuteStartAt(
              value,
              _cronExpression.minute.everyStartMinute,
            );
          },
        ),
        Text('minute(s)'),
      ],
    );
  }

  Widget _hourlyPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Every'),
        _dropdownButtonFromList<int>(
          'hourly_every_hour',
          _cronExpression.hour.getHourList(),
          _cronExpression.hour.everyHour,
          (value) {
            _cronExpression.hour.setEveryHourStartAt(
              value,
              _cronExpression.hour.everyStartHour,
            );
          },
        ),
        Text('hour(s) on minute'),
        _dropdownButtonFromList<int>(
          'hourly_specific_minutes',
          _cronExpression.minute.getMinuteList(),
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
        Text('Every'),
        _dropdownButtonFromList<int>(
          'daily_every_day',
          _cronExpression.dayOfMonth.getDayList(),
          _cronExpression.dayOfMonth.everyDay,
          (value) {
            _cronExpression.dayOfMonth.setEveryStartAtMonth(
              value,
              _cronExpression.dayOfMonth.everyStartDay,
            );
          },
        ),
        Text('day(s) at'),
        _dropdownButtonFromList<int>(
          'daily_specific_hours',
          _cronExpression.hour.getHourList(),
          _cronExpression.hour.specificHours[0],
          (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromList<int>(
          'daily_specific_minutes',
          _cronExpression.minute.getMinuteList(),
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
        ..._cronExpression.dayOfWeek.getWeekdayList().map((weekday) {
          return _checkboxListTile(weekday);
        }).toList(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Start time'),
            _dropdownButtonFromList<int>(
              'weekly_specific_hours',
              _cronExpression.hour.getHourList(),
              _cronExpression.hour.specificHours[0],
                  (value) {
                _cronExpression.hour.setSpecificHours([value]);
              },
            ),
            _dropdownButtonFromList<int>(
              'weekly_specific_minutes',
              _cronExpression.minute.getMinuteList(),
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
        Text('On the'),
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
        Text('of every'),
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
        Text('at'),
        _dropdownButtonFromList<int>(
          'monthly_specific_hours',
          _cronExpression.hour.getHourList(),
          _cronExpression.hour.specificHours[0],
              (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromList<int>(
          'monthly_specific_minutes',
          _cronExpression.minute.getMinuteList(),
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
        Text('On the'),
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
        Text('of'),
        _dropdownButtonFromList<String>(
          'monthly_every_month',
          _cronExpression.month.getMonthList(),
          _cronExpression.month.specificMonths[0],
              (value) {
            _cronExpression.month.setSpecificMonths([value]);
          },
        ),
        Text('at'),
        _dropdownButtonFromList<int>(
          'monthly_specific_hours',
          _cronExpression.hour.getHourList(),
          _cronExpression.hour.specificHours[0],
              (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromList<int>(
          'monthly_specific_minutes',
          _cronExpression.minute.getMinuteList(),
          _cronExpression.minute.specificMinutes[0],
              (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }

  Widget _checkboxListTile(String weekday) {
    return CheckboxListTile(
      title: Text(weekday),
      // controlAffinity: ListTileControlAffinity.leading,
      value: _cronExpression.dayOfWeek.specificWeekdays.contains(weekday),
      onChanged: (bool? value) {
        _cronExpression.dayOfWeek.toggleSpecificWeekday(weekday);
        setState(() {});
      },
    );
  }
}
