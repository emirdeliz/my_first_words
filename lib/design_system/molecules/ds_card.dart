import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';

/// Molecular Card component com props tipadas
class DSCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? shadowColor;
  final VoidCallback? onTap;
  
  // Border Radius Props
  final bool br1;
  final bool br2;
  final bool br3;
  final bool br4;
  final bool br5;
  final bool br6;
  
  // Elevation Props
  final bool elev0;
  final bool elev1;
  final bool elev2;
  final bool elev3;
  final bool elev4;
  final bool elev5;
  
  // Padding Props
  final bool sp1;
  final bool sp2;
  final bool sp3;
  final bool sp4;
  final bool sp5;
  final bool sp6;
  final bool sp7;
  final bool sp8;
  final bool sp9;

  const DSCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.shadowColor,
    this.onTap,
    this.br1 = false,
    this.br2 = false,
    this.br3 = false,
    this.br4 = false,
    this.br5 = false,
    this.br6 = false,
    this.elev0 = false,
    this.elev1 = false,
    this.elev2 = false,
    this.elev3 = false,
    this.elev4 = false,
    this.elev5 = false,
    this.sp1 = false,
    this.sp2 = false,
    this.sp3 = false,
    this.sp4 = false,
    this.sp5 = false,
    this.sp6 = false,
    this.sp7 = false,
    this.sp8 = false,
    this.sp9 = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = TokenMapper.getBorderRadius(
      br1: br1,
      br2: br2,
      br3: br3,
      br4: br4,
      br5: br5,
      br6: br6,
    );
    
    final elevation = TokenMapper.getElevation(
      elev0: elev0,
      elev1: elev1,
      elev2: elev2,
      elev3: elev3,
      elev4: elev4,
      elev5: elev5,
    );
    
    final padding = EdgeInsets.all(TokenMapper.getSpacing(
      sp1: sp1,
      sp2: sp2,
      sp3: sp3,
      sp4: sp4,
      sp5: sp5,
      sp6: sp6,
      sp7: sp7,
      sp8: sp8,
      sp9: sp9,
    ));

    Widget cardChild = Padding(
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      cardChild = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardChild,
      );
    }

    return Card(
      elevation: elevation,
      color: backgroundColor,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: cardChild,
    );
  }
}
