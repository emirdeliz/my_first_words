import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';
import '../atoms/ds_text.dart';
import '../atoms/ds_icon.dart';

/// Molecular Input component
class DSInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool enabled;
  
  // Border Radius Props
  final bool br1;
  final bool br2;
  final bool br3;
  final bool br4;
  
  // Size variants
  final bool small;
  final bool large;

  const DSInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.br1 = false,
    this.br2 = false,
    this.br3 = false,
    this.br4 = false,
    this.small = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = TokenMapper.getBorderRadius(
      br1: br1,
      br2: br2,
      br3: br3,
      br4: br4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          DSBody(label!, small: small, large: large),
          const SizedBox(height: DesignTokens.spaceSM),
        ],
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          enabled: enabled,
          style: TextStyle(
            fontSize: small
                ? DesignTokens.fontSizeSM
                : large
                    ? DesignTokens.fontSizeLG
                    : DesignTokens.fontSizeMD,
          ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? DSIcon(
                    prefixIcon!,
                    icon2: small,
                    icon3: !small && !large,
                    icon4: large,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixIconTap,
                    child: DSIcon(
                      suffixIcon!,
                      icon2: small,
                      icon3: !small && !large,
                      icon4: large,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(
              small
                  ? DesignTokens.spaceMD
                  : large
                      ? DesignTokens.spaceXL
                      : DesignTokens.spaceLG,
            ),
          ),
        ),
      ],
    );
  }
}
