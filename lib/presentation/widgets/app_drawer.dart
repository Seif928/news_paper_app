import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';

/// A top-level navigation destination, shared by the mobile [AppDrawer] and
/// the tablet/desktop [AppNavigationRail] so both always stay in sync.
class AppDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String titleKey;
  final String route;

  const AppDestination({
    required this.icon,
    required this.selectedIcon,
    required this.titleKey,
    required this.route,
  });

  static const List<AppDestination> primary = [
    AppDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      titleKey: 'Home',
      route: AppRoutes.homePageRoute,
    ),
    AppDestination(
      icon: Icons.search,
      selectedIcon: Icons.search,
      titleKey: 'Search',
      route: AppRoutes.searchPageRoute,
    ),
    AppDestination(
      icon: Icons.bookmark_border,
      selectedIcon: Icons.bookmark,
      titleKey: 'Saved',
      route: AppRoutes.savedPageRoute,
    ),
    AppDestination(
      icon: Icons.notifications_none,
      selectedIcon: Icons.notifications,
      titleKey: 'Notifications',
      route: AppRoutes.notificationPageRoute,
    ),
  ];

  static const AppDestination settings = AppDestination(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    titleKey: 'Settings',
    route: AppRoutes.settingsPageRoute,
  );

  /// Destinations shown in the rail (settings included as the last item).
  static const List<AppDestination> all = [...primary, settings];
}

const String _logoAsset =
    'assets/logos/al-akhbar-mauritania-logo-png_seeklogo-505945.png';

/// Mobile navigation drawer (compact screens).
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.locale;
    } catch (_) {}
    return Drawer(
      child: SafeArea(
        // Scrollable so the drawer never overflows on short screens
        // (e.g. phones in landscape), while keeping Settings pinned to the
        // bottom when there is enough room.
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  for (final destination in AppDestination.primary)
                    _buildDrawerItem(context, destination),
                  const Spacer(),
                  const Divider(height: 32, indent: 16, endIndent: 16),
                  _buildDrawerItem(context, AppDestination.settings),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16),
            child: CircleAvatar(
              radius: 40,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  _logoAsset,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: theme.colorScheme.onSurface,
                      size: 35,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Al Akhbar'.tr(), style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Your daily news'.tr(), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, AppDestination destination) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == destination.route;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          destination.icon,
          color: isSelected ? colorScheme.secondary : colorScheme.onSurface,
        ),
        selectedColor: isSelected ? colorScheme.secondary : null,
        title: Text(
          destination.titleKey.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isSelected ? colorScheme.secondary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.secondary.withValues(alpha: 0.08),
        onTap: () {
          Navigator.of(context).pop();
          if (currentRoute == destination.route) return;
          Navigator.of(context).pushNamed(destination.route);
        },
      ),
    );
  }
}

/// Persistent navigation for medium (rail) and expanded (sidebar) screens.
class AppNavigationRail extends StatelessWidget {
  /// When true the rail shows labels next to icons and the brand name.
  final bool extended;

  const AppNavigationRail({super.key, required this.extended});

  @override
  Widget build(BuildContext context) {
    try {
      context.locale;
    } catch (_) {}
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final selected = AppDestination.all.indexWhere(
      (d) => d.route == currentRoute,
    );

    return NavigationRail(
      extended: extended,
      minExtendedWidth: 232,
      scrollable: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      indicatorColor: colorScheme.secondary.withValues(alpha: 0.12),
      selectedIconTheme: IconThemeData(color: colorScheme.secondary),
      selectedLabelTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.secondary,
      ),
      unselectedLabelTextStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
      leading: _RailBrand(extended: extended),
      selectedIndex: selected == -1 ? null : selected,
      onDestinationSelected: (index) {
        final route = AppDestination.all[index].route;
        if (currentRoute == route) return;
        Navigator.of(context).pushNamed(route);
      },
      destinations: [
        for (final d in AppDestination.all)
          NavigationRailDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.titleKey.tr()),
          ),
      ],
    );
  }
}

class _RailBrand extends StatelessWidget {
  final bool extended;

  const _RailBrand({required this.extended});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logo = CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.surface,
      child: ClipOval(
        child: Image.asset(
          _logoAsset,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          errorBuilder:
              (_, __, ___) =>
                  Icon(Icons.newspaper, color: theme.colorScheme.secondary),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child:
          extended
              ? SizedBox(
                width: 200,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    logo,
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Al Akhbar'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              )
              : Semantics(label: 'Al Akhbar'.tr(), child: logo),
    );
  }
}
