import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool elevated;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  const MyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.elevated = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.yellow;
    final fg = foregroundColor ?? Colors.black;
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(bg),
      foregroundColor: WidgetStateProperty.all(fg),
      padding: WidgetStateProperty.all(
        padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );

    if (elevated) {
      return ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return TextButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
