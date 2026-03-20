import 'package:cron_form_field/cron_expression.dart';
import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:flutter/material.dart';

/// A dialog for editing cron expressions with expandable panels.
///
/// Use [CronPickerDialog.show] as a convenient way to open the dialog:
/// ```dart
/// final result = await CronPickerDialog.show(
///   context: context,
///   value: '0 0 */3 ? * *',
/// );
/// ```
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
    this.btnDoneText = 'Done',
    this.btnCancelText = 'Cancel',
    this.outputFormat = CronExpressionOutputFormat.auto,
  }) : super(key: key);

  /// Shows the cron picker dialog and returns the selected cron expression
  /// string, or null if cancelled.
  static Future<String?> show({
    required BuildContext context,
    required String value,
    String? title,
    String btnDoneText = 'Done',
    String btnCancelText = 'Cancel',
    CronExpressionOutputFormat outputFormat = CronExpressionOutputFormat.auto,
  }) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return CronPickerDialog(
          value: value,
          title: title,
          btnDoneText: btnDoneText,
          btnCancelText: btnCancelText,
          outputFormat: outputFormat,
        );
      },
    );
  }

  @override
  CronPickerDialogState createState() => CronPickerDialogState();
}

enum _PanelType {
  none,
  seconds,
  minutes,
  hourly,
  daily,
  weekly,
  monthly,
  yearly
}

class CronPickerDialogState extends State<CronPickerDialog> {
  late CronExpression _cronExpression;
  _PanelType _opened = _PanelType.none;

  bool get _isQuartz => _cronExpression.type == CronExpressionType.quartz;

  @override
  void initState() {
    super.initState();

    _cronExpression = CronExpression.fromString(widget.value);
  }

  void _openPanel(_PanelType panelType, void Function() setupDefaults) {
    setState(() {
      if (_opened == panelType) {
        _opened = _PanelType.none;
      } else {
        setupDefaults();
        _opened = panelType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ''),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cronExpressionText(),
              if (_isQuartz)
                _buildExpansionTile(
                  key: 'seconds',
                  title: 'Seconds',
                  panelType: _PanelType.seconds,
                  child: _secondsPanel(),
                  onOpen: () {
                    _cronExpression.reset();
                    _cronExpression.second.setEverySecondStartAt(1);
                  },
                ),
              _buildExpansionTile(
                key: 'minutes',
                title: 'Minutes',
                panelType: _PanelType.minutes,
                child: _minutesPanel(),
                onOpen: () {
                  _cronExpression.reset();
                  _cronExpression.minute.setEveryMinuteStartAt(1);
                },
              ),
              _buildExpansionTile(
                key: 'hourly',
                title: 'Hourly',
                panelType: _PanelType.hourly,
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
              _buildExpansionTile(
                key: 'daily',
                title: 'Daily',
                panelType: _PanelType.daily,
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
              _buildExpansionTile(
                key: 'weekly',
                title: 'Weekly',
                panelType: _PanelType.weekly,
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
              _buildExpansionTile(
                key: 'monthly',
                title: 'Monthly',
                panelType: _PanelType.monthly,
                child: _monthlyPanel(),
                onOpen: () {
                  _cronExpression.reset();
                  _cronExpression.second
                      .setSpecificSeconds([_cronExpression.second.startIndex]);
                  _cronExpression.minute
                      .setSpecificMinutes([_cronExpression.minute.startIndex]);
                  _cronExpression.hour
                      .setSpecificHours([_cronExpression.hour.startIndex]);
                  _cronExpression.dayOfWeek.setXthDayOfMonth(
                      _cronExpression.dayOfWeek.startIndex, 1);
                  _cronExpression.month.setEveryMonthStartAt(1);
                },
              ),
              _buildExpansionTile(
                key: 'yearly',
                title: 'Yearly',
                panelType: _PanelType.yearly,
                child: _yearlyPanel(),
                onOpen: () {
                  _cronExpression.reset();
                  _cronExpression.second
                      .setSpecificSeconds([_cronExpression.second.startIndex]);
                  _cronExpression.minute
                      .setSpecificMinutes([_cronExpression.minute.startIndex]);
                  _cronExpression.hour
                      .setSpecificHours([_cronExpression.hour.startIndex]);
                  _cronExpression.dayOfWeek.setXthDayOfMonth(
                      _cronExpression.dayOfWeek.startIndex, 1);
                  _cronExpression.month
                      .setSpecificMonths([_cronExpression.month.startIndex]);
                },
              ),
            ],
          ),
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

  Widget _cronExpressionText() {
    final expressionString =
        _cronExpression.toFormatString(widget.outputFormat);
    final readableString = _cronExpression.toReadableString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(
          children: [
            Semantics(
              label: 'Cron expression: $expressionString',
              child: Text(
                expressionString,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
            if (readableString.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  readableString,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
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

  Widget _buildExpansionTile({
    required String key,
    required String title,
    required _PanelType panelType,
    required Widget child,
    required void Function() onOpen,
  }) {
    final isOpen = _opened == panelType;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ExpansionTile(
        key: ValueKey(key),
        title: Text(title),
        initiallyExpanded: isOpen,
        onExpansionChanged: (expanded) {
          if (expanded) {
            _openPanel(panelType, onOpen);
          } else {
            setState(() {
              _opened = _PanelType.none;
            });
          }
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _secondsPanel() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Every'),
        _dropdownButtonFromMap<int, String>(
          'seconds_every_second',
          _cronExpression.second.getEverySecondMap(),
          _cronExpression.second.everySecond,
          (value) {
            _cronExpression.second.setEverySecondStartAt(
              value,
              _cronExpression.second.everyStartSecond,
            );
          },
        ),
        const Text('second(s)'),
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
          return CheckboxListTile(
            title: Text(weekday.value),
            value: _cronExpression.dayOfWeek.specificWeekdays
                .contains(weekday.key),
            onChanged: (bool? value) {
              _cronExpression.dayOfWeek.toggleSpecificWeekday(weekday.key);
              setState(() {});
            },
          );
        }),
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
          'yearly_xth_weeks',
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
          'yearly_xth_weekday',
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
          'yearly_specific_month',
          _cronExpression.month.getMonthMap(),
          _cronExpression.month.specificMonths[0],
          (value) {
            _cronExpression.month.setSpecificMonths([value]);
          },
        ),
        const Text('at'),
        _dropdownButtonFromMap<int, String>(
          'yearly_specific_hours',
          _cronExpression.hour.getHourMap(),
          _cronExpression.hour.specificHours[0],
          (value) {
            _cronExpression.hour.setSpecificHours([value]);
          },
        ),
        _dropdownButtonFromMap<int, String>(
          'yearly_specific_minutes',
          _cronExpression.minute.getMinuteMap(),
          _cronExpression.minute.specificMinutes[0],
          (value) {
            _cronExpression.minute.setSpecificMinutes([value]);
          },
        ),
      ],
    );
  }
}
