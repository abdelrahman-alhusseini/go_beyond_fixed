import 'package:flutter/material.dart';

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.options,
    this.icon,
    this.showLoadingIndicator = true,
  });

  final VoidCallback? onPressed;
  final String text;
  final FFButtonOptions options;
  final Widget? icon;
  final bool showLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options.width,
      height: options.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: options.color,
          foregroundColor: options.textStyle?.color,
          elevation: options.elevation,
          padding: options.padding,
          side: options.borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: options.borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        child: icon == null
            ? Text(text, style: options.textStyle)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Text(text, style: options.textStyle),
                ],
              ),
      ),
    );
  }
}

class FFButtonOptions {
  const FFButtonOptions({
    this.width,
    this.height,
    this.padding,
    this.iconPadding,
    this.color,
    this.textStyle,
    this.elevation,
    this.borderSide,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;
  final Color? color;
  final TextStyle? textStyle;
  final double? elevation;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;
}