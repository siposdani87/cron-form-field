// Copyright 2021 The siposdani87 Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library cron_form_field;

import 'package:cron_form_field/src/enums/cron_expression_output_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cron_form_field/src/cron_picker_dialog.dart';

export 'package:cron_form_field/src/enums/cron_expression_output_format.dart';

/// A [CronFormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [CronFormField].
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
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to [dispose] of the [TextEditingController] when it is no longer needed.
/// This will ensure we discard any resources used by the object.
///
/// For a documentation about the various parameters, see [TextField].
///
/// {@tool snippet}
///
/// Creates a [CronFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// CronFormField(
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   onSaved: (String value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String value) {
///     return value.contains('@') ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateful_widget_material}
/// This example shows how to move the focus to the next field when the user
/// presses the ENTER key.
///
/// ```dart imports
/// import 'package:flutter/services.dart';
/// ```
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Material(
///     child: Center(
///       child: Shortcuts(
///         shortcuts: <LogicalKeySet, Intent>{
///           // Pressing enter on the field will now move to the next field.
///           LogicalKeySet(LogicalKeyboardKey.enter):
///               Intent(NextFocusAction.key),
///         },
///         child: FocusTraversalGroup(
///           child: Form(
///             autovalidate: true,
///             onChanged: () {
///               Form.of(primaryFocus.context).save();
///             },
///             child: Wrap(
///               children: List<Widget>.generate(5, (int index) {
///                 return Padding(
///                   padding: const EdgeInsets.all(8.0),
///                   child: ConstrainedBox(
///                     constraints: BoxConstraints.tight(Size(200, 50)),
///                     child: CronFormField(
///                       onSaved: (String value) {
///                         print('Value for field $index saved as "$value"');
///                       },
///                     ),
///                   ),
///                 );
///               }),
///             ),
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipe]s.(https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller)
class CronFormField extends FormField<String> {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// An icon to show before the input field and outside of the decoration's
  /// container.
  ///
  /// The size and color of the icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The trailing edge of the icon is padded by 16dps.
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [decoration.icon] and above the widgets that contain [helperText],
  /// [errorText], and [counterText].
  ///
  /// See [Icon], [ImageIcon].
  final Widget? icon;

  /// Text that describes the input field.
  ///
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), the label moves above (i.e.,
  /// vertically adjacent to) the input field.
  final String? labelText;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the input [child] (i.e., at the same location on the
  /// screen where text may be entered in the input [child]) when the input
  /// [isEmpty] and either (a) [labelText] is null or (b) the input has the focus.
  final String? hintText;

  /// The title of the dialog window.
  final String? dialogTitle;

  /// The done button text on dialog
  final String dialogDoneText;

  /// The cancel button text on dialog
  final String dialogCancelText;

  final CronExpressionOutputFormat? outputFormat;

  /// The value change event
  final ValueChanged<String>? onChanged;

  /// Creates a [CronFormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [new TextField], the constructor.
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
    this.outputFormat = CronExpressionOutputFormat.AUTO,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    Widget Function(BuildContext, EditableTextState)? contextMenuBuilder,
    bool? showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    //GestureTapCallback onTap,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
  })  : assert(initialValue == null || controller == null),
        assert(maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          !expands || minLines == null,
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(
          !obscureText || maxLines == 1,
          'Obscured fields cannot be multiline.',
        ),
        assert(maxLength == null || maxLength > 0),
        super(
          key: key,
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          // autovalidate: autovalidate,
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
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: autofocus,
              contextMenuBuilder: contextMenuBuilder,
              readOnly: true,
              showCursor: showCursor,
              obscureText: obscureText,
              autocorrect: autocorrect,
              smartDashesType: smartDashesType ??
                  (obscureText
                      ? SmartDashesType.disabled
                      : SmartDashesType.enabled),
              smartQuotesType: smartQuotesType ??
                  (obscureText
                      ? SmartQuotesType.disabled
                      : SmartQuotesType.enabled),
              enableSuggestions: enableSuggestions,
              // maxLengthEnforced: maxLengthEnforced,
              maxLines: maxLines,
              minLines: minLines,
              expands: expands,
              maxLength: maxLength,
              onChanged: state.onChangedHandler,
              onTap: readOnly ? null : state._showCronFormFieldDialog,
              onEditingComplete: onEditingComplete,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding,
              scrollPhysics: scrollPhysics,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection,
              buildCounter: buildCounter,
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
    String? newValue = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return CronPickerDialog(
          value: _controller.text,
          title: widget.dialogTitle ?? widget.labelText,
          btnDoneText: widget.dialogDoneText,
          btnCancelText: widget.dialogCancelText,
          outputFormat: widget.outputFormat!,
        );
      },
    );
    if (newValue != null) {
      _controller.text = newValue;
    }
  }
}
