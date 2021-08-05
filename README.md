# cron_form_field

[![pub package](https://img.shields.io/pub/v/cron_form_field.svg)](https://pub.dartlang.org/packages/cron_form_field)

<a href="https://www.buymeacoffee.com/siposdani87" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-green.png" alt="Buy Me A Coffee" style="width: 150px !important;"></a>

This CronFormField package written in Dart for the Flutter.\
You can edit cron expressions with this form field in a alert dialog.\
This widget extend TextField to has more useful behaviour.

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  cron_form_field: "^0.0.1"
```

In your library add the following import:

```dart
import 'package:cron_form_field/cron_form_field.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Example

``` dart
CronFormField(
  initialValue: '0 0 */3 ? * * *',
  // controller: _cronController,
  labelText: 'Scheduler',
  onChanged: (val) => print(val),
  onSaved: (val) => print(val),
);
```

The result of val in `onChanged`, `validator` and `onSaved` will be a String.\

## Preview
![Overview](https://raw.githubusercontent.com/siposdani87/cron_form_field/master/doc/images/cron_form_field.png)
