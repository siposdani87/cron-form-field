# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter package (`cron_form_field`) that provides a form field widget for editing cron expressions via an alert dialog picker. Published on pub.dev. Supports both Standard (5-part) and Quartz (6-7 part, uses `?`) cron expression formats.

## Commands

- **Run unit tests:** `flutter test test/unit_test.dart`
- **Run widget tests:** `flutter test test/cron_form_field_test.dart`
- **Run all tests:** `flutter test`
- **Analyze:** `flutter analyze`
- **Run example app:** `cd example && flutter run`

## Architecture

Two public entry points:
- `lib/cron_form_field.dart` — `CronFormField` widget (extends `FormField<String>`, wraps a read-only `TextField` that opens `CronPickerDialog` on tap)
- `lib/cron_expression.dart` — `CronExpression` model (parses/serializes cron strings, holds part objects)

Internal structure in `lib/src/`:
- **`CronPart`** (abstract) — interface for all cron parts: `reset()`, `setDefaults()`, `toString()`, `toReadableString()`, `validate()`
- **`CronTimePart`** — base class for `CronSecond`, `CronMinute`, `CronHour` (shared logic for time-based parts)
- **Part classes** (`cron_second.dart`, `cron_minute.dart`, `cron_hour.dart`, `cron_month.dart`, `cron_year.dart`) — each implements `CronPart`
- **`CronDay`** — composite that holds both `DayOfMonth` and `DayOfWeek` (day-of-month and day-of-week are mutually exclusive in Quartz format)
- **`CronPickerDialog`** — `AlertDialog` with `ExpansionTile` panels (Seconds, Minutes, Hourly, Daily, Weekly, Monthly, Yearly) that manipulate `CronExpression` state
- **Enums** in `enums/` — `CronExpressionType`, `CronExpressionOutputFormat`, and per-part type enums (all use lowerCamelCase)

## Key Conventions

- Dart SDK constraint: `>=3.0.0 <4.0.0`, Flutter `>=3.10.0`
- Linting: `flutter_lints: ^6.0.0`
- Lint rules: prefer single quotes, prefer trailing commas, newline before return
- CI runs `flutter analyze` + `flutter test` + `dart format` check on push/PR to `master`
- CI publishes to pub.dev on tag push via OIDC auth
