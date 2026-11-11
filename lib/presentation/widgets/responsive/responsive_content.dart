import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:news_paper_app/core/utils/responsive.dart';

/// Centers [child] inside the available width, capping it at [maxWidth] and
/// applying the responsive horizontal gutter.
///
/// Uses the *available* width (not the window width) so it behaves correctly
/// next to a navigation rail.
class ResponsiveContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = LayoutSizes.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = ResponsiveSliverPadding.sidePadding(
          constraints.maxWidth,
          maxWidth,
        );
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: side),
          child: padding == null ? child : Padding(padding: padding!, child: child),
        );
      },
    );
  }
}

/// Sliver equivalent of [ResponsiveContent].
///
/// The scroll view itself stays full-width (so the scrollbar sits at the
/// window edge on Web/desktop) while the content is centered and capped at
/// [maxWidth].
class ResponsiveSliverPadding extends StatelessWidget {
  final Widget sliver;
  final double maxWidth;
  final double top;
  final double bottom;

  const ResponsiveSliverPadding({
    super.key,
    required this.sliver,
    this.maxWidth = LayoutSizes.maxContentWidth,
    this.top = 0,
    this.bottom = 0,
  });

  /// Horizontal padding that centers content of [maxWidth] inside
  /// [available], never smaller than the responsive gutter.
  static double sidePadding(double available, double maxWidth) {
    final gutter = Responsive.gutterFor(available);
    if (!available.isFinite) return gutter;
    return math.max(gutter, (available - maxWidth) / 2);
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = sidePadding(constraints.crossAxisExtent, maxWidth);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(side, top, side, bottom),
          sliver: sliver,
        );
      },
    );
  }
}
