import 'package:flutter/material.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';

/// Page scaffold used by secondary top-level pages (Saved, Notifications,
/// Settings).
///
/// * Compact: the original mobile look — a centered [AppBar] (with the drawer
///   button when [showDrawer] is true, otherwise the default back button).
/// * Medium and wider: the navigation rail is provided by `ResponsiveShell`,
///   so instead of an app bar the page shows an in-content header aligned to
///   the same max width as the body.
class ResponsivePageScaffold extends StatelessWidget {
  /// Title shown in the compact [AppBar].
  final Widget compactTitle;

  /// Title shown in the wide in-content header. `null` hides the header.
  final Widget? wideTitle;

  final List<Widget> compactActions;
  final List<Widget> wideActions;

  /// Whether the compact layout exposes the [AppDrawer].
  final bool showDrawer;

  /// Max width of the wide header (should match the body).
  final double maxWidth;

  final Color? backgroundColor;
  final Widget body;

  const ResponsivePageScaffold({
    super.key,
    required this.compactTitle,
    required this.body,
    this.wideTitle,
    this.compactActions = const [],
    this.wideActions = const [],
    this.showDrawer = false,
    this.maxWidth = LayoutSizes.maxContentWidth,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);

    if (size.isCompact) {
      return Scaffold(
        backgroundColor: backgroundColor,
        drawer: showDrawer ? const AppDrawer() : null,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: backgroundColor,
          surfaceTintColor: backgroundColor,
          title: compactTitle,
          actions: compactActions,
        ),
        body: body,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (wideTitle != null)
              ResponsiveContent(
                maxWidth: maxWidth,
                padding: const EdgeInsets.only(top: 28, bottom: 20),
                child: Row(
                  children: [
                    if (Navigator.of(context).canPop()) ...[
                      const BackButton(),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: DefaultTextStyle.merge(
                        style: Theme.of(context).textTheme.headlineMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: wideTitle!,
                      ),
                    ),
                    ...wideActions,
                  ],
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
