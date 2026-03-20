/// Holds all user-facing strings used by [CronPickerDialog].
///
/// Override individual labels to localize the picker:
/// ```dart
/// CronPickerDialog(
///   value: '* * * * *',
///   labels: CronPickerLabels(
///     seconds: 'Secondes',
///     minutes: 'Minutes',
///     done: 'Valider',
///     cancel: 'Annuler',
///   ),
/// )
/// ```
class CronPickerLabels {
  final String seconds;
  final String minutes;
  final String hourly;
  final String daily;
  final String weekly;
  final String monthly;
  final String yearly;
  final String year;
  final String done;
  final String cancel;
  final String every;
  final String secondUnit;
  final String minuteUnit;
  final String hoursOnMinute;
  final String daysAt;
  final String startTime;
  final String onThe;
  final String ofEvery;
  final String of;
  final String at;
  final String yearsStartingIn;

  const CronPickerLabels({
    this.seconds = 'Seconds',
    this.minutes = 'Minutes',
    this.hourly = 'Hourly',
    this.daily = 'Daily',
    this.weekly = 'Weekly',
    this.monthly = 'Monthly',
    this.yearly = 'Yearly',
    this.year = 'Year',
    this.done = 'Done',
    this.cancel = 'Cancel',
    this.every = 'Every',
    this.secondUnit = 'second(s)',
    this.minuteUnit = 'minute(s)',
    this.hoursOnMinute = 'hour(s) on minute',
    this.daysAt = 'day(s) at',
    this.startTime = 'Start time',
    this.onThe = 'On the',
    this.ofEvery = 'of every',
    this.of = 'of',
    this.at = 'at',
    this.yearsStartingIn = 'year(s) starting in',
  });
}
