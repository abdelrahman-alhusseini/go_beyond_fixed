import 'package:flutter/material.dart';

import 'form_field_controller.dart';

class ChipData {
  const ChipData(this.label, {this.icon});
  final String label;
  final Widget? icon;
}

class ChipStyle {
  const ChipStyle({
    this.backgroundColor,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
}

class FlutterFlowChoiceChips extends StatefulWidget {
  const FlutterFlowChoiceChips({
    super.key,
    required this.options,
    required this.onChanged,
    required this.selectedChipStyle,
    required this.unselectedChipStyle,
    required this.controller,
    this.chipSpacing = 8,
    this.rowSpacing = 8,
    this.multiselect = false,
    this.alignment = WrapAlignment.start,
    this.wrapped = true,
  });

  final List<ChipData> options;
  final ValueChanged<List<String>?> onChanged;
  final ChipStyle selectedChipStyle;
  final ChipStyle unselectedChipStyle;
  final FormFieldController<List<String>> controller;
  final double chipSpacing;
  final double rowSpacing;
  final bool multiselect;
  final WrapAlignment alignment;
  final bool wrapped;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.controller.value ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.chipSpacing,
      runSpacing: widget.rowSpacing,
      alignment: widget.alignment,
      children: widget.options.map((option) {
        final isSelected = selectedValues.contains(option.label);
        final style = isSelected ? widget.selectedChipStyle : widget.unselectedChipStyle;

        return ChoiceChip(
          label: Text(option.label, style: style.textStyle),
          selected: isSelected,
          backgroundColor: widget.unselectedChipStyle.backgroundColor,
          selectedColor: widget.selectedChipStyle.backgroundColor,
          side: BorderSide(color: style.borderColor ?? Colors.transparent, width: style.borderWidth ?? 0),
          shape: RoundedRectangleBorder(borderRadius: style.borderRadius ?? BorderRadius.circular(8)),
          onSelected: (_) {
            setState(() {
              if (widget.multiselect) {
                if (isSelected) {
                  selectedValues.remove(option.label);
                } else {
                  selectedValues.add(option.label);
                }
              } else {
                selectedValues = [option.label];
              }
              widget.controller.value = selectedValues;
              widget.onChanged(selectedValues);
            });
          },
        );
      }).toList(),
    );
  }
}
