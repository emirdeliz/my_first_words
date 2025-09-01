import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';

/// Atomic Icon component com props tipadas
class DSIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  
  // Icon Size Props (apenas uma deve ser true)
  final bool icon1;
  final bool icon2;
  final bool icon3;
  final bool icon4;
  final bool icon5;
  final bool icon6;
  final bool icon7;
  final bool icon8;

  const DSIcon(
    this.icon, {
    super.key,
    this.color,
    this.icon1 = false,
    this.icon2 = false,
    this.icon3 = false,
    this.icon4 = false,
    this.icon5 = false,
    this.icon6 = false,
    this.icon7 = false,
    this.icon8 = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = TokenMapper.getIconSize(
      icon1: icon1,
      icon2: icon2,
      icon3: icon3,
      icon4: icon4,
      icon5: icon5,
      icon6: icon6,
      icon7: icon7,
      icon8: icon8,
    );

    return Icon(
      icon,
      size: size,
      color: color,
    );
  }
}
