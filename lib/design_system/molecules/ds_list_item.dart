import 'package:flutter/material.dart';
import '../atoms/ds_text.dart';
import '../atoms/ds_icon.dart';
import '../tokens/design_tokens.dart';

/// Molecular ListItem component
class DSListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;

  // Title size variants
  final bool titleLarge;
  final bool titleSmall;

  // Subtitle size variants
  final bool subtitleLarge;
  final bool subtitleSmall;

  // Icon size variants
  final bool icon1;
  final bool icon2;
  final bool icon3;
  final bool icon4;
  final bool icon5;

  const DSListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.titleLarge = false,
    this.titleSmall = false,
    this.subtitleLarge = false,
    this.subtitleSmall = false,
    this.icon1 = false,
    this.icon2 = false,
    this.icon3 = false,
    this.icon4 = false,
    this.icon5 = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon != null
          ? DSIcon(
              leadingIcon!,
              color: iconColor,
              icon1: icon1,
              icon2: icon2,
              icon3: !icon1 && !icon2 && !icon4 && !icon5,
              icon4: icon4,
              icon5: icon5,
            )
          : null,
      title: titleLarge
          ? DSTitle(title, color: titleColor)
          : titleSmall
              ? DSCaption(title, color: titleColor)
              : DSSubtitle(title, color: titleColor),
      subtitle: subtitle != null
          ? (subtitleLarge
              ? DSSubtitle(subtitle!, color: subtitleColor)
              : subtitleSmall
                  ? DSCaption(subtitle!, color: subtitleColor)
                  : DSBody(subtitle!, color: subtitleColor, small: true))
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceLG,
        vertical: DesignTokens.spaceSM,
      ),
    );
  }
}
