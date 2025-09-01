import 'package:flutter/material.dart';
import '../tokens/design_tokens.dart';

/// Atomic Spacing component com props tipadas
class DSSpacing extends StatelessWidget {
  // Vertical Spacing Props
  final bool sp1;
  final bool sp2;
  final bool sp3;
  final bool sp4;
  final bool sp5;
  final bool sp6;
  final bool sp7;
  final bool sp8;
  final bool sp9;
  
  // Horizontal Spacing Props
  final bool horizontal;

  const DSSpacing({
    super.key,
    this.sp1 = false,
    this.sp2 = false,
    this.sp3 = false,
    this.sp4 = false,
    this.sp5 = false,
    this.sp6 = false,
    this.sp7 = false,
    this.sp8 = false,
    this.sp9 = false,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = TokenMapper.getSpacing(
      sp1: sp1,
      sp2: sp2,
      sp3: sp3,
      sp4: sp4,
      sp5: sp5,
      sp6: sp6,
      sp7: sp7,
      sp8: sp8,
      sp9: sp9,
    );

    return SizedBox(
      width: horizontal ? spacing : null,
      height: !horizontal ? spacing : null,
    );
  }
}

/// Pre-defined spacing variants
class DSVerticalSpacing extends DSSpacing {
  const DSVerticalSpacing.xs({super.key}) : super(sp1: true);
  const DSVerticalSpacing.sm({super.key}) : super(sp2: true);
  const DSVerticalSpacing.md({super.key}) : super(sp3: true);
  const DSVerticalSpacing.lg({super.key}) : super(sp4: true);
  const DSVerticalSpacing.xl({super.key}) : super(sp5: true);
  const DSVerticalSpacing.xl2({super.key}) : super(sp6: true);
  const DSVerticalSpacing.xl3({super.key}) : super(sp7: true);
  const DSVerticalSpacing.xl4({super.key}) : super(sp8: true);
  const DSVerticalSpacing.xl5({super.key}) : super(sp9: true);
}

class DSHorizontalSpacing extends DSSpacing {
  const DSHorizontalSpacing.xs({super.key}) : super(sp1: true, horizontal: true);
  const DSHorizontalSpacing.sm({super.key}) : super(sp2: true, horizontal: true);
  const DSHorizontalSpacing.md({super.key}) : super(sp3: true, horizontal: true);
  const DSHorizontalSpacing.lg({super.key}) : super(sp4: true, horizontal: true);
  const DSHorizontalSpacing.xl({super.key}) : super(sp5: true, horizontal: true);
  const DSHorizontalSpacing.xl2({super.key}) : super(sp6: true, horizontal: true);
  const DSHorizontalSpacing.xl3({super.key}) : super(sp7: true, horizontal: true);
  const DSHorizontalSpacing.xl4({super.key}) : super(sp8: true, horizontal: true);
  const DSHorizontalSpacing.xl5({super.key}) : super(sp9: true, horizontal: true);
}
