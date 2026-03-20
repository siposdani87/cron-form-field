// Copyright 2021 The siposdani87 Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library;

import 'package:cron_form_field/cron_expression.dart';
import 'package:cron_form_field/src/cron_picker_labels.dart';
import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:flutter/material.dart';
import 'package:cron_form_field/src/cron_picker_dialog.dart';

export 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
export 'package:cron_form_field/src/cron_picker_dialog.dart'
    show CronPickerDialog;
export 'package:cron_form_field/src/cron_picker_labels.dart';

/// A form field for editing cron expressions via a picker dialog.
///
/// This widget wraps a read-only [TextField] that opens a [CronPickerDialog]
/// when tapped. It supports both Standard and Quartz cron expression formats.
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// ```dart
/// CronFormField(
///   initialValue: '0 0 */3 ? * *',
///   labelText: 'Schedule',
///   onChanged: (val) => print(val),
///   onSaved: (val) => print(val),
/// )
/// ```
class CronFormField extends FormField<String> {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// The decoration to show around the text field.
  ///
  /// If null, a default decoration with [labelText], [hintText], [icon],
  /// and a dropdown arrow suffix icon will be used.
  final InputDecoration? decoration;

  /// Text that describes the input field. Used in the default decoration
  /// when [decoration] is null, and as the dialog title fallback.
  final String? labelText;

  /// Text that suggests what sort of input the field accepts. Used in the
  /// default decoration when [decoration] is null.
  final String? hintText;

  /// An icon to show before the input field. Used in the default decoration
  /// when [decoration] is null.
  final Widget? icon;

  /// The title of the dialog window. Falls back to [labelText] if null.
  final String? dialogTitle;

  /// The done button text on dialog.
  @Deprecated('Use labels.done instead')
  final String? dialogDoneText;

  /// The cancel button text on dialog.
  @Deprecated('Use labels.cancel instead')
  final String? dialogCancelText;

  /// The output format for the cron expression.
  final CronExpressionOutputFormat outputFormat;

  /// Labels for the picker dialog. Override to localize.
  final CronPickerLabels labels;

  /// Called when the string value changes.
  final ValueChanged<String>? onChanged;

  /// Called when the cron expression changes, providing the parsed
  /// [CronExpression] object for direct access to individual parts.
  final ValueChanged<CronExpression>? onCronExpressionChanged;

  /// Creates a [CronFormField] that contains a read-only [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  CronFormField({
    super.key,
    this.controller,
    this.decoration,
    this.icon,
    this.labelText,
    this.hintText,
    this.dialogTitle,
    @Deprecated('Use labels.cancel instead') this.dialogCancelText,
    @Deprecated('Use labels.done instead') this.dialogDoneText,
    this.onChanged,
    this.onCronExpressionChanged,
    this.outputFormat = CronExpressionOutputFormat.auto,
    this.labels = const CronPickerLabels(),
    String? initialValue,
    FocusNode? focusNode,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled = true,
  })  : assert(initialValue == null || controller == null),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          builder: (FormFieldState<String> formFieldState) {
            final CronFormFieldState state =
                formFieldState as CronFormFieldState;

            final InputDecoration effectiveDecoration = decoration ??
                InputDecoration(
                  labelText: labelText,
                  icon: icon,
                  hintText: hintText,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                );
            effectiveDecoration.applyDefaults(
              Theme.of(state.context).inputDecorationTheme,
            );

            return TextField(
              controller: state._controller,
              focusNode: focusNode,
              decoration: effectiveDecoration.copyWith(
                errorText: state.errorText,
              ),
              style: style,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              autofocus: autofocus,
              readOnly: true,
              onChanged: state.onChangedHandler,
              onTap: readOnly ? null : state._showCronFormFieldDialog,
              enabled: enabled,
            );
          },
        );

  @override
  CronFormFieldState createState() => CronFormFieldState();
}

class CronFormFieldState extends FormFieldState<String> {
  late TextEditingController _valueController;
  late String _initialValue;

  @override
  CronFormField get widget => super.widget as CronFormField;

  TextEditingController get _controller =>
      widget.controller ?? _valueController;

  @override
  void initState() {
    super.initState();

    _valueController = TextEditingController(text: value);

    _initialValue = _controller.text;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);

    super.dispose();
  }

  @override
  void reset() {
    super.reset();

    setState(() {
      _controller.text = _initialValue;
    });
  }

  void _handleControllerChanged() {
    onChangedHandler(_controller.text);
  }

  void onChangedHandler(String newValue) {
    if (newValue != value) {
      widget.onChanged?.call(newValue);
      widget.onCronExpressionChanged?.call(
        CronExpression.fromString(newValue),
      );
      didChange(newValue);
    }
  }

  Future<void> _showCronFormFieldDialog() async {
    String? newValue = await CronPickerDialog.show(
      context: context,
      value: _controller.text,
      title: widget.dialogTitle ?? widget.labelText,
      // ignore: deprecated_member_use_from_same_package
      btnDoneText: widget.dialogDoneText,
      // ignore: deprecated_member_use_from_same_package
      btnCancelText: widget.dialogCancelText,
      outputFormat: widget.outputFormat,
      labels: widget.labels,
    );
    if (newValue != null) {
      _controller.text = newValue;
    }
  }
}
