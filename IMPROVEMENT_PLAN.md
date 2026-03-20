# Improvement Plan for cron_form_field

## Phase 1 — Critical: Dart 3 Compatibility ✅ DONE

- ✅ **1.1** SDK constraint bumped to `>=3.0.0 <4.0.0`, Flutter `>=3.10.0`
- ✅ **1.2** Removed `dart_code_metrics` (deprecated). Kept `flutter_lints`. Cleaned `analysis_options.yaml`.
- ✅ **1.3** Removed deprecated `autovalidate`, `maxLengthEnforced`, and ~20 cargo-culted params (`obscureText`, `autocorrect`, `maxLines`, `inputFormatters`, etc.). Added `autovalidateMode`. Removed unused `import 'package:flutter/services.dart'`.

## Phase 2 — Bug Fixes ✅ DONE

- ✅ **2.1** Fixed "OKT" → "OCT" typo in `cron_month.dart`
- ✅ **2.2** Fixed `getRange(0, length - 2)` → `getRange(0, length - 1)` off-by-one in 7 files
- ✅ **2.3** Implemented regex-based `validate()` in all 7 part classes
- ✅ **2.4** Fixed `DayOfMonth.getType()` — reordered checks so `LW` and `L-` are matched before plain `-`
- ✅ **2.5** Changed `outputFormat` from nullable to non-nullable
- ✅ **2.6** Fixed duplicate `'monthly_*'` widget keys in yearly panel → `'yearly_*'`

## Phase 3 — pub.dev Score & Documentation ✅ DONE

- ✅ Added `topics`, `screenshots`, `repository`, `issue_tracker` to `pubspec.yaml`
- ✅ Fixed README badge URL to `pub.dev`
- ✅ Added `///` doc comments to `CronExpression`, `CronPart`, `CronPickerDialog`, `CronFormField`, and enum types

## Phase 4 — Testing ✅ DONE

- ✅ **Unit tests expanded** from 27 to 74 tests covering: `toReadableString()`, output formats, mutation methods, `reset()`, malformed input, expression type detection, OCT fix, off-by-one fix, DayOfMonth.getType fix
- ✅ **Widget tests rewritten** with 8 tests: render, dialog open, Cancel, Done, Minutes panel, Hourly panel, Weekly panel (7 checkboxes), readable description, panel-then-Done value change
- ✅ **CI workflow added** (`ci.yml`) with `flutter analyze` + `flutter test` + `dart format` check

## Phase 5 — Architecture ✅ MOSTLY DONE

- ✅ **5.2** Renamed all enum values from `UPPER_CASE` to `lowerCamelCase` across 8 enum files and all references. Re-enabled `constant_identifier_names` lint.
- ✅ **5.4** Removed `CronEntity` class and file. All part classes now directly `implements CronPart`.
- ✅ **5.5** Removed empty `dispose()` override in `CronPickerDialogState`
- ✅ **5.6** Fixed `_MyHomePageState` → `MyHomePageState` in example (lint warning)
- ✅ **5.1** Extracted `CronTimePart` base class — `CronSecond`, `CronMinute`, `CronHour` are now thin subclasses (~30 lines each vs ~150 before). Deleted unused `CronSecondType`, `CronMinuteType`, `CronHourType` enums.
- **5.3** Deferred: Making `CronExpression` fields private requires reworking the dialog's mutation pattern

## Phase 6 — API & UX Enhancements ✅ PARTIALLY DONE

- ✅ Added static `CronPickerDialog.show()` for standalone use without the form field
- ✅ Exported `CronPickerDialog` from the main library
- ✅ Dialog `ConstrainedBox(maxWidth: 400)` for tablet/desktop/web
- ✅ Show `toReadableString()` below the raw cron expression in dialog
- ✅ Cron expression displayed in monospace font for clarity
- ✅ Added `Semantics` label on cron expression display
- ✅ Rounded panel borders (0 → 4px radius)
- ✅ Made `PanelType` enum private (`_PanelType`) — implementation detail
- ✅ Added `onCronExpressionChanged` callback exposing parsed `CronExpression` object
- ✅ Made `decoration` a proper named field with doc comments clarifying the fallback behavior
- Panel state preservation — `reset()` wipes config when switching panels (future)
- Add missing Seconds panel to dialog UI (future)
- Replace custom panels with `ExpansionTile` for Material 3 theming (future)

## Phase 7 — CI/CD Modernization ✅ DONE

- ✅ Updated `actions/checkout@v1` to `@v4` in publish workflow
- ✅ Replaced unmaintained `sakebook/actions-flutter-pub-publisher` with `subosito/flutter-action` + `dart pub publish`
- ✅ Added CI workflow with test + analyze + format checks
- Add branch protection requiring CI to pass

## Suggested Implementation Order

| Phase | Effort | Impact | Status |
|-------|--------|--------|--------|
| 1 — Dart 3 compat | Small | **Highest** | ✅ Done |
| 2 — Bug fixes | Small | High | ✅ Done |
| 3 — pub.dev score | Small | Medium | ✅ Done |
| 7 — CI/CD | Small | Low-medium | ✅ Done |
| 4 — Testing | Medium | Medium | ✅ Done (74 unit + 8 widget) |
| 5 — Architecture | Large | Medium | ✅ Done |
| 6 — API/UX | Large | Medium | ✅ Mostly done |
