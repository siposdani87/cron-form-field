// Copyright 2021 The siposdani87 Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library cron_form_field;

import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:flutter/material.dart';
import 'package:cron_form_field/src/cron_picker_dialog.dart';

export 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
export 'package:cron_form_field/src/cron_picker_dialog.dart' show CronPickerDialog;

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

  /// An icon to show before the input field and outside of the decoration's
  /// container.
  final Widget? icon;

  /// Text that describes the input field.
  final String? labelText;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// The title of the dialog window.
  final String? dialogTitle;

  /// The done button text on dialog.
  final String dialogDoneText;

  /// The cancel button text on dialog.
  final String dialogCancelText;

  /// The output format for the cron expression.
  final CronExpressionOutputFormat outputFormat;

  /// Called when the value changes.
  final ValueChanged<String>? onChanged;

  /// Creates a [CronFormField] that contains a read-only [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  CronFormField({
    Key? key,
    this.controller,
    this.icon,
    this.labelText,
    this.hintText,
    this.dialogTitle,
    this.dialogCancelText = 'Cancel',
    this.dialogDoneText = 'Done',
    this.onChanged,
    this.outputFormat = CronExpressionOutputFormat.auto,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
  })  : assert(initialValue == null || controller == null),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
          enabled: enabled,
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
      didChange(newValue);
    }
  }

  Future<void> _showCronFormFieldDialog() async {
    String? newValue = await CronPickerDialog.show(
      context: context,
      value: _controller.text,
      title: widget.dialogTitle ?? widget.labelText,
      btnDoneText: widget.dialogDoneText,
      btnCancelText: widget.dialogCancelText,
      outputFormat: widget.outputFormat,
    );
    if (newValue != null) {
      _controller.text = newValue;
    }
  }
}
