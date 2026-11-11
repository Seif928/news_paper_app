import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Window-size classes used across the app.
///
/// Layout decisions are based on the available width only (never on the
/// platform), so a narrow browser window gets the phone layout and a tablet
/// in landscape gets the wider layout.
enum ScreenSize {
  /// < 600 logical pixels (phones).
  compact,

  /// 600 – 1023 logical pixels (tablets, small windows).
  medium,

  /// 1024 – 1439 logical pixels (laptops, tablets in landscape).
  expanded,

  /// >= 1440 logical pixels (desktop monitors).
  large;

  static ScreenSize fromWidth(double width) {
    if (width >= Breakpoints.large) return ScreenSize.large;
    if (width >= Breakpoints.expanded) return ScreenSize.expanded;
    if (width >= Breakpoints.medium) return ScreenSize.medium;
    return ScreenSize.compact;
  }

  bool get isCompact => this == ScreenSize.compact;
  bool get isMedium => this == ScreenSize.medium;
  bool get isLarge => this == ScreenSize.large;

  /// True for [expanded] and [large].
  bool get isExpandedOrLarger => index >= ScreenSize.expanded.index;

  /// True for every size except [compact].
  bool get isMediumOrLarger => index >= ScreenSize.medium.index;
}

/// Breakpoint values (logical pixels).
abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 1024;
  static const double large = 1440;
}

/// Shared layout dimensions so screens don't hardcode their own values.
abstract final class LayoutSizes {
  /// Max width of the main content area (feeds, grids).
  static const double maxContentWidth = 1320;

  /// Comfortable line length for long-form reading (article body, policy).
  static const double maxReadingWidth = 760;

  /// Max width for list-style pages (notifications, settings, search lists).
  static const double maxListWidth = 840;

  /// Max width for forms (login / register).
  static const double maxFormWidth = 440;

  /// Spacing between grid cells.
  static double gridSpacing(ScreenSize size) => size.isCompact ? 12 : 24;

  /// Vertical spacing between page sections.
  static double sectionSpacing(ScreenSize size) => size.isCompact ? 28 : 40;
}

class Responsive {
  Responsive._();

  /// The [ScreenSize] of the whole window. Uses [MediaQuery.sizeOf] so the
  /// caller only rebuilds when the size changes.
  static ScreenSize of(BuildContext context) =>
      ScreenSize.fromWidth(MediaQuery.sizeOf(context).width);

  /// Returns true if the screen width is less than 600px (Mobile)
  static bool isCompact(BuildContext context) => of(context).isCompact;

  /// Returns true if the screen width is between 600px and 1023px (Tablet)
  static bool isMedium(BuildContext context) => of(context).isMedium;

  /// Returns true if the screen width is 1024px or greater (Web/Desktop)
  static bool isExpanded(BuildContext context) =>
      of(context).isExpandedOrLarger;

  /// Returns true if the screen width is 1440px or greater.
  static bool isLarge(BuildContext context) => of(context) == ScreenSize.large;

  /// Horizontal page gutter for a given available width.
  static double gutterFor(double width) {
    switch (ScreenSize.fromWidth(width)) {
      case ScreenSize.compact:
        return 16;
      case ScreenSize.medium:
        return 24;
      case ScreenSize.expanded:
        return 32;
      case ScreenSize.large:
        return 40;
    }
  }

  /// Number of grid columns that fit in [width] so that every cell is at
  /// least [minItemWidth] wide, clamped to `1..maxColumns`.
  static int columnsFor(
    double width, {
    required double minItemWidth,
    double spacing = 16,
    int maxColumns = 4,
  }) {
    final columns = ((width + spacing) / (minItemWidth + spacing)).floor();
    return math.max(1, math.min(columns, maxColumns));
  }

  /// A helper widget to return different widgets based on the screen size
  static Widget layout({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isExpanded(context)) {
      return desktop ?? tablet ?? mobile;
    }
    if (isMedium(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
