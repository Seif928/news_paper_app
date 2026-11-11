import 'package:flutter/material.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';

/// Wraps every top-level page with the navigation pattern for the current
/// window size:
///
/// * compact  (< 600):   no wrapper — pages keep their own app bar / drawer.
/// * medium   (600-1023): compact [NavigationRail] with labels.
/// * expanded (>= 1024): extended rail (sidebar) with branding.
class ResponsiveShell extends StatelessWidget {
  final Widget child;

  const ResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);

    if (size.isCompact) return child;

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            right: false,
            child: AppNavigationRail(extended: size.isExpandedOrLarger),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
