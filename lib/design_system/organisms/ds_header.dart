import 'package:flutter/material.dart';
import '../atoms/ds_text.dart';
import '../atoms/ds_icon.dart';
import '../atoms/ds_spacing.dart';
import '../tokens/design_tokens.dart';

/// Organism Header component
class DSHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  
  // Title size variants
  final bool titleLarge;
  final bool titleSmall;

  const DSHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.titleLarge = false,
    this.titleSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleLarge
          ? DSTitle(title, large: true, color: foregroundColor)
          : titleSmall
              ? DSSubtitle(title, color: foregroundColor)
              : DSTitle(title, color: foregroundColor),
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      elevation: DesignTokens.elevationSM,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Organism Custom Header with more flexibility
class DSCustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingTap;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  
  // Padding Props
  final bool sp1;
  final bool sp2;
  final bool sp3;
  final bool sp4;
  final bool sp5;
  final bool sp6;

  const DSCustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.onLeadingTap,
    this.actions,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.sp1 = false,
    this.sp2 = false,
    this.sp3 = false,
    this.sp4 = false,
    this.sp5 = false,
    this.sp6 = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(TokenMapper.getSpacing(
      sp1: sp1,
      sp2: sp2,
      sp3: sp3,
      sp4: sp4 || (!sp1 && !sp2 && !sp3 && !sp5 && !sp6), // default
      sp5: sp5,
      sp6: sp6,
    ));

    return Container(
      height: height,
      color: backgroundColor,
      padding: padding.copyWith(
        top: padding.top + MediaQuery.of(context).padding.top,
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            GestureDetector(
              onTap: onLeadingTap,
              child: DSIcon(
                leadingIcon!,
                color: textColor,
                icon4: true,
              ),
            ),
            const DSHorizontalSpacing.md(),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DSTitle(title, color: textColor),
                if (subtitle != null) ...[
                  const DSVerticalSpacing.xs(),
                  DSBody(subtitle!, color: textColor, small: true),
                ],
              ],
            ),
          ),
          if (actions != null) ...[
            const DSHorizontalSpacing.md(),
            ...actions!,
          ],
        ],
      ),
    );
  }
}
