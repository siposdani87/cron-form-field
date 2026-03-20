## 1.0.0 - 2026-03-20

### BREAKING CHANGES

* Require Dart >=3.0.0 and Flutter >=3.10.0
* Rename all enum values from UPPER_CASE to lowerCamelCase (e.g., `CronExpressionType.QUARTZ` → `CronExpressionType.quartz`, `CronExpressionOutputFormat.AUTO` → `CronExpressionOutputFormat.auto`)
* Remove deprecated `autovalidate` and `maxLengthEnforced` constructor params (use `autovalidateMode` instead)
* Remove unused constructor params: `obscureText`, `autocorrect`, `maxLines`, `minLines`, `expands`, `maxLength`, `keyboardType`, `textInputAction`, `smartDashesType`, `smartQuotesType`, `enableSuggestions`, `inputFormatters`, `buildCounter`, `cursorWidth`, `cursorRadius`, `cursorColor`, `scrollPadding`, `scrollPhysics`, `keyboardAppearance`, `enableInteractiveSelection`, `contextMenuBuilder`, `showCursor`, `strutStyle`, `textDirection`, `textCapitalization`, `onEditingComplete`, `onFieldSubmitted`
* Remove `CronEntity` base class — part classes now implement `CronPart` directly
* Remove `CronSecondType`, `CronMinuteType`, `CronHourType` enums (replaced by `CronTimePartType` in `CronTimePart` base class)

### Bug Fixes

* Fix "OKT" typo → "OCT" in month names
* Fix off-by-one in `toReadableString()` across all part classes (`getRange(0, length-2)` → `getRange(0, length-1)`)
* Fix `DayOfMonth.getType()` misclassifying ranges like `1-15` as `DAY_BEFORE_END_OF_MONTH`
* Fix duplicate widget keys in yearly panel (`monthly_*` → `yearly_*`)
* Make `outputFormat` non-nullable with default value

### New Features

* Add `CronPickerDialog.show()` static method for standalone dialog use
* Export `CronPickerDialog` from the main library
* Add `onCronExpressionChanged` callback exposing parsed `CronExpression` object
* Add Seconds panel in dialog for Quartz expressions
* Show human-readable description below cron expression in dialog
* Add regex-based `validate()` in all part classes

### Improvements

* Extract `CronTimePart` base class — `CronSecond`, `CronMinute`, `CronHour` are now thin subclasses
* Replace custom expandable panels with `ExpansionTile` for Material 3 theming
* Only reset expression when opening a new panel, not when collapsing
* Add `ConstrainedBox(maxWidth: 400)` for tablet/desktop/web
* Display cron expression in monospace font
* Add `Semantics` label on expression display
* Add `///` doc comments to public API classes and enums
* Add CI workflow with `flutter analyze`, `flutter test`, `dart format`
* Modernize publish workflow: `actions/checkout@v4`, `subosito/flutter-action`
* Add pub.dev metadata: `topics`, `screenshots`, `repository`, `issue_tracker`
* Expand tests from 27 to 86 (77 unit + 9 widget)


## 0.6.0 - 2023-02-15

* Support Flutter 3.7
* Upgrade dependencies 

## 0.5.0 - 2022-07-15

* Support Flutter 3
* Upgrade dependencies

## 0.4.0 - 2022-02-25

* Fix index of dayOfWeek and month values
* Rename parent var to cronDay
* Improve QUARTZ and STANDARD cron handlers

## 0.3.0 - 2022-02-24

* Add outputFormat property (default: CronExpressionOutputFormat.AUTO)
* Fix dart lint issues
* Upgrade dependencies

## 0.2.0 - 2021-08-05

* Updated cron expression parser

## 0.0.1 - 2021-07-28

* Initial release
