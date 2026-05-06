import 'package:flutter/material.dart';

class FlutterFlowIconButton extends StatelessWidget {
  const FlutterFlowIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.buttonSize,
    this.fillColor,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? buttonSize;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize ?? 40,
      height: buttonSize ?? 40,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}