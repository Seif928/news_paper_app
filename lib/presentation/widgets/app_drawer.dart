import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const SizedBox(height: 16),

            _buildDrawerItem(
              context,
              icon: Icons.home_outlined,
              title: 'Home'.tr(),
              route: AppRoutes.homePageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.search,
              title: 'Search'.tr(),
              route: AppRoutes.searchPageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.bookmark_border,
              title: 'Saved'.tr(),
              route: AppRoutes.savedPageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.notifications_none,
              title: 'Notifications'.tr(),
              route: AppRoutes.notificationPageRoute,
            ),

            const Divider(height: 32, indent: 16, endIndent: 16),

            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings'.tr(),
              route: AppRoutes.settingsPageRoute,
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
          CircleAvatar(
            foregroundImage: AssetImage(
              'assets/images/photo_2026-07-16_03-07-31.jpg',
            ),
            onForegroundImageError:
                (exception, stackTrace) => Icon(
                  Icons.person,
                  color: theme.colorScheme.onSurface,
                  size: 30,
                ),
            radius: 30,
          ),

          const SizedBox(height: 16),

          Text('Al Akhbar'.tr(), style: theme.textTheme.headlineSmall),

          const SizedBox(height: 4),

          Text('Your daily news'.tr(), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? colorScheme.secondary : colorScheme.onSurface,
        ),
        selectedColor: isSelected ? colorScheme.secondary : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isSelected ? colorScheme.secondary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.secondary.withValues(alpha: 0.08),
        onTap: () {
          Navigator.of(context).pop();

          if (currentRoute == route) {
            return;
          }

          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}
