import 'package:flutter/material.dart';

import 'form_field_controller.dart';

class FlutterFlowDropDown<T> extends StatelessWidget {
  const FlutterFlowDropDown({
    super.key,
    required this.options,
    required this.onChanged,
    this.controller,
    this.width,
    this.height,
    this.textStyle,
    this.hintText,
    this.icon,
    this.fillColor,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.margin,
    this.hidesUnderline = true,
    this.isOverButton = false,
    this.isSearchable = false,
    this.isMultiSelect = false,
  });

  final FormFieldController<T>? controller;
  final List<T> options;
  final ValueChanged<T?> onChanged;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String? hintText;
  final Widget? icon;
  final Color? fillColor;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final bool hidesUnderline;
  final bool isOverButton;
  final bool isSearchable;
  final bool isMultiSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: margin ?? const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: Border.all(color: borderColor ?? Colors.transparent, width: borderWidth ?? 0),
      ),
      child: DropdownButton<T>(
        value: controller?.value,
        hint: hintText == null ? null : Text(hintText!),
        isExpanded: true,
        underline: hidesUnderline ? const SizedBox.shrink() : null,
        icon: icon,
        style: textStyle,
        items: options.map((option) => DropdownMenuItem<T>(value: option, child: Text(option.toString()))).toList(),
        onChanged: (value) {
          controller?.value = value;
          onChanged(value);
        },
      ),
    );
  }
}
