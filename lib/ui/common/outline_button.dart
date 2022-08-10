import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Color? color, splashColor;
  final void Function()? onPressed;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;

  OutlineButton({
    Key? key,
    this.padding,
    this.border,
    this.color,
    this.splashColor,
    this.onPressed,
    this.child,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonThemeData buttonTheme = ButtonTheme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding,
        backgroundColor: color,
        shape: borderRadius != null ? RoundedRectangleBorder(borderRadius: borderRadius!) : null,
      ),
      child: child ?? SizedBox(),
    );
  }
}
