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
- **`CronEntity`** — base class holding `originalValue` string
- **Part classes** (`cron_second.dart`, `cron_minute.dart`, `cron_hour.dart`, `cron_month.dart`, `cron_year.dart`) — each extends `CronEntity` and implements `CronPart`
- **`CronDay`** — composite that holds both `DayOfMonth` and `DayOfWeek` (day-of-month and day-of-week are mutually exclusive in Quartz format)
- **`CronPickerDialog`** — `AlertDialog` with expandable panels (Minutes, Hourly, Daily, Weekly, Monthly, Yearly) that manipulate `CronExpression` state
- **Enums** in `enums/` — `CronExpressionType` (STANDARD/QUARTZ), `CronExpressionOutputFormat` (AUTO/numeric/named), and per-part type enums

## Key Conventions

- Dart SDK constraint: `>=2.12.0 <3.0.0` (null safety enabled)
- Linting: `flutter_lints` + `dart_code_metrics` (cyclomatic complexity ≤20, max nesting ≤5, params ≤7, SLOC ≤80)
- Lint rules: prefer single quotes, prefer trailing commas, newline before return
- `constant_identifier_names` lint is disabled (enums use UPPER_CASE)
- CI publishes to pub.dev on push to `master`
