import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';
import 'ds_text.dart';
import 'ds_icon.dart';

/// Atomic Button component com props tipadas
class DSButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  
  // Button Variants
  final bool primary;
  final bool secondary;
  final bool outlined;
  final bool ghost;
  final bool danger;
  
  // Size Props
  final bool small;
  final bool medium;
  final bool large;
  
  // Border Radius Props
  final bool br1;
  final bool br2;
  final bool br3;
  final bool br4;
  final bool round;
  
  // Padding Props
  final bool sp1;
  final bool sp2;
  final bool sp3;
  final bool sp4;
  final bool sp5;
  final bool sp6;

  const DSButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.primary = false,
    this.secondary = false,
    this.outlined = false,
    this.ghost = false,
    this.danger = false,
    this.small = false,
    this.medium = false,
    this.large = false,
    this.br1 = false,
    this.br2 = false,
    this.br3 = false,
    this.br4 = false,
    this.round = false,
    this.sp1 = false,
    this.sp2 = false,
    this.sp3 = false,
    this.sp4 = false,
    this.sp5 = false,
    this.sp6 = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = TokenMapper.getBorderRadius(
      br1: br1,
      br2: br2,
      br3: br3,
      br4: br4,
      round: round,
    );
    
    final padding = EdgeInsets.all(TokenMapper.getSpacing(
      sp1: sp1,
      sp2: sp2,
      sp3: sp3,
      sp4: sp4,
      sp5: sp5,
      sp6: sp6,
    ));

    // Determine button style based on variant
    Color? bgColor = backgroundColor;
    Color? fgColor = foregroundColor;
    BorderSide? border;

    if (primary) {
      bgColor ??= theme.colorScheme.primary;
      fgColor ??= theme.colorScheme.onPrimary;
    } else if (secondary) {
      bgColor ??= theme.colorScheme.secondary;
      fgColor ??= theme.colorScheme.onSecondary;
    } else if (outlined) {
      bgColor ??= Colors.transparent;
      fgColor ??= theme.colorScheme.primary;
      border = BorderSide(color: borderColor ?? theme.colorScheme.primary);
    } else if (ghost) {
      bgColor ??= Colors.transparent;
      fgColor ??= theme.colorScheme.primary;
    } else if (danger) {
      bgColor ??= theme.colorScheme.error;
      fgColor ??= theme.colorScheme.onError;
    }

    Widget child;
    
    if (text != null && icon != null) {
      // Icon + Text button
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DSIcon(
            icon!,
            color: fgColor,
            icon2: small,
            icon3: !small && !large,
            icon4: large,
          ),
          SizedBox(width: TokenMapper.getSpacing(sp2: true)),
          DSBody(
            text!,
            color: fgColor,
            small: small,
            large: large,
          ),
        ],
      );
    } else if (icon != null) {
      // Icon only button
      child = DSIcon(
        icon!,
        color: fgColor,
        icon2: small,
        icon3: !small && !large,
        icon4: large,
      );
    } else {
      // Text only button
      child = DSBody(
        text ?? '',
        color: fgColor,
        small: small,
        large: large,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        side: border,
        padding: padding.copyWith(
          top: padding.top + (large ? 4 : small ? -2 : 0),
          bottom: padding.bottom + (large ? 4 : small ? -2 : 0),
          left: padding.left + (large ? 8 : small ? -4 : 0),
          right: padding.right + (large ? 8 : small ? -4 : 0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: child,
    );
  }
}
