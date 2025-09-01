import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';

/// Atomic Text component com props tipadas
class DSText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  // Font Size Props (apenas uma deve ser true)
  final bool fs1;
  final bool fs2;
  final bool fs3;
  final bool fs4;
  final bool fs5;
  final bool fs6;
  final bool fs7;
  final bool fs8;

  const DSText(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fs1 = false,
    this.fs2 = false,
    this.fs3 = false,
    this.fs4 = false,
    this.fs5 = false,
    this.fs6 = false,
    this.fs7 = false,
    this.fs8 = false,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = TokenMapper.getFontSize(
      fs1: fs1,
      fs2: fs2,
      fs3: fs3,
      fs4: fs4,
      fs5: fs5,
      fs6: fs6,
      fs7: fs7,
      fs8: fs8,
    );

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Text variants for common use cases
class DSTitle extends DSText {
  const DSTitle(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    bool large = false,
    bool xl = false,
  }) : super(
          fontWeight: DesignTokens.fontWeightBold,
          fs6: !large && !xl,
          fs7: large,
          fs8: xl,
        );
}

class DSSubtitle extends DSText {
  const DSSubtitle(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    bool small = false,
  }) : super(
          fontWeight: DesignTokens.fontWeightMedium,
          fs3: small,
          fs4: !small,
        );
}

class DSBody extends DSText {
  const DSBody(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
    bool small = false,
    bool large = false,
  }) : super(
          fontWeight: DesignTokens.fontWeightRegular,
          fs2: small,
          fs3: !small && !large,
          fs4: large,
        );
}

class DSCaption extends DSText {
  const DSCaption(
    super.text, {
    super.key,
    super.color,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
          fontWeight: DesignTokens.fontWeightRegular,
          fs1: true,
        );
}
