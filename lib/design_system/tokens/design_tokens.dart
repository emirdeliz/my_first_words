import 'package:flutter/material.dart';

/// Design tokens para garantir consistência visual
class DesignTokens {
  // Typography Scale
  static const double fontSizeXS = 12.0;  // fs1
  static const double fontSizeSM = 14.0;  // fs2
  static const double fontSizeMD = 16.0;  // fs3 (base)
  static const double fontSizeLG = 18.0;  // fs4
  static const double fontSizeXL = 20.0;  // fs5
  static const double fontSize2XL = 24.0; // fs6
  static const double fontSize3XL = 28.0; // fs7
  static const double fontSize4XL = 32.0; // fs8

  // Spacing Scale
  static const double spaceXS = 4.0;   // sp1
  static const double spaceSM = 8.0;   // sp2
  static const double spaceMD = 12.0;  // sp3
  static const double spaceLG = 16.0;  // sp4 (base)
  static const double spaceXL = 20.0;  // sp5
  static const double space2XL = 24.0; // sp6
  static const double space3XL = 32.0; // sp7
  static const double space4XL = 40.0; // sp8
  static const double space5XL = 48.0; // sp9

  // Border Radius Scale
  static const double radiusXS = 4.0;  // br1
  static const double radiusSM = 8.0;  // br2
  static const double radiusMD = 12.0; // br3 (base)
  static const double radiusLG = 16.0; // br4
  static const double radiusXL = 20.0; // br5
  static const double radius2XL = 24.0; // br6
  static const double radiusRound = 999.0; // br-round

  // Icon Sizes
  static const double iconXS = 16.0;  // icon1
  static const double iconSM = 20.0;  // icon2
  static const double iconMD = 24.0;  // icon3 (base)
  static const double iconLG = 28.0;  // icon4
  static const double iconXL = 32.0;  // icon5
  static const double icon2XL = 40.0; // icon6
  static const double icon3XL = 48.0; // icon7
  static const double icon4XL = 64.0; // icon8

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Elevation Scale
  static const double elevationNone = 0.0;  // elev0
  static const double elevationXS = 1.0;    // elev1
  static const double elevationSM = 2.0;    // elev2
  static const double elevationMD = 4.0;    // elev3
  static const double elevationLG = 8.0;    // elev4
  static const double elevationXL = 12.0;   // elev5
}

/// Utility class para mapear props booleanas para valores de token
class TokenMapper {
  // Font Size Mapper
  static double getFontSize({
    bool fs1 = false,
    bool fs2 = false, 
    bool fs3 = false,
    bool fs4 = false,
    bool fs5 = false,
    bool fs6 = false,
    bool fs7 = false,
    bool fs8 = false,
  }) {
    if (fs1) return DesignTokens.fontSizeXS;
    if (fs2) return DesignTokens.fontSizeSM;
    if (fs3) return DesignTokens.fontSizeMD;
    if (fs4) return DesignTokens.fontSizeLG;
    if (fs5) return DesignTokens.fontSizeXL;
    if (fs6) return DesignTokens.fontSize2XL;
    if (fs7) return DesignTokens.fontSize3XL;
    if (fs8) return DesignTokens.fontSize4XL;
    return DesignTokens.fontSizeMD; // default
  }

  // Spacing Mapper
  static double getSpacing({
    bool sp1 = false,
    bool sp2 = false,
    bool sp3 = false,
    bool sp4 = false,
    bool sp5 = false,
    bool sp6 = false,
    bool sp7 = false,
    bool sp8 = false,
    bool sp9 = false,
  }) {
    if (sp1) return DesignTokens.spaceXS;
    if (sp2) return DesignTokens.spaceSM;
    if (sp3) return DesignTokens.spaceMD;
    if (sp4) return DesignTokens.spaceLG;
    if (sp5) return DesignTokens.spaceXL;
    if (sp6) return DesignTokens.space2XL;
    if (sp7) return DesignTokens.space3XL;
    if (sp8) return DesignTokens.space4XL;
    if (sp9) return DesignTokens.space5XL;
    return DesignTokens.spaceLG; // default
  }

  // Border Radius Mapper
  static double getBorderRadius({
    bool br1 = false,
    bool br2 = false,
    bool br3 = false,
    bool br4 = false,
    bool br5 = false,
    bool br6 = false,
    bool round = false,
  }) {
    if (br1) return DesignTokens.radiusXS;
    if (br2) return DesignTokens.radiusSM;
    if (br3) return DesignTokens.radiusMD;
    if (br4) return DesignTokens.radiusLG;
    if (br5) return DesignTokens.radiusXL;
    if (br6) return DesignTokens.radius2XL;
    if (round) return DesignTokens.radiusRound;
    return DesignTokens.radiusMD; // default
  }

  // Icon Size Mapper
  static double getIconSize({
    bool icon1 = false,
    bool icon2 = false,
    bool icon3 = false,
    bool icon4 = false,
    bool icon5 = false,
    bool icon6 = false,
    bool icon7 = false,
    bool icon8 = false,
  }) {
    if (icon1) return DesignTokens.iconXS;
    if (icon2) return DesignTokens.iconSM;
    if (icon3) return DesignTokens.iconMD;
    if (icon4) return DesignTokens.iconLG;
    if (icon5) return DesignTokens.iconXL;
    if (icon6) return DesignTokens.icon2XL;
    if (icon7) return DesignTokens.icon3XL;
    if (icon8) return DesignTokens.icon4XL;
    return DesignTokens.iconMD; // default
  }

  // Elevation Mapper
  static double getElevation({
    bool elev0 = false,
    bool elev1 = false,
    bool elev2 = false,
    bool elev3 = false,
    bool elev4 = false,
    bool elev5 = false,
  }) {
    if (elev0) return DesignTokens.elevationNone;
    if (elev1) return DesignTokens.elevationXS;
    if (elev2) return DesignTokens.elevationSM;
    if (elev3) return DesignTokens.elevationMD;
    if (elev4) return DesignTokens.elevationLG;
    if (elev5) return DesignTokens.elevationXL;
    return DesignTokens.elevationSM; // default
  }
}
