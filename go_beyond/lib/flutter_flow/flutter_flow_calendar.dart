import 'package:flutter/material.dart';

class FlutterFlowCalendar extends StatefulWidget {
  const FlutterFlowCalendar({
    super.key,
    required this.color,
    this.iconColor,
    this.weekFormat = false,
    this.weekStartsMonday = false,
    this.rowHeight = 48,
    required this.onChange,
    this.titleStyle,
    this.dayOfWeekStyle,
    this.dateStyle,
    this.selectedDateStyle,
    this.inactiveDateStyle,
  });

  final Color color;
  final Color? iconColor;
  final bool weekFormat;
  final bool weekStartsMonday;
  final double rowHeight;
  final void Function(DateTimeRange?) onChange;
  final TextStyle? titleStyle;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? dateStyle;
  final TextStyle? selectedDateStyle;
  final TextStyle? inactiveDateStyle;

  @override
  State<FlutterFlowCalendar> createState() => _FlutterFlowCalendarState();
}

class _FlutterFlowCalendarState extends State<FlutterFlowCalendar> {
  DateTime selectedDay = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => selectedDay = picked);
      widget.onChange(DateTimeRange(start: picked, end: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: widget.color),
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Selected Date', style: widget.titleStyle),
      subtitle: Text('${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}'),
      trailing: Icon(Icons.calendar_month, color: widget.iconColor ?? widget.color),
      onTap: _pickDate,
    );
  }
}
