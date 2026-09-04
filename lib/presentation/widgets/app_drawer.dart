import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const SizedBox(height: 16),

            _buildDrawerItem(
              context,
              icon: Icons.home_outlined,
              title: 'Home',
              route: AppRoutes.homePageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.search,
              title: 'Search',
              route: AppRoutes.searchPageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.bookmark_border,
              title: 'Favorites',
              route: AppRoutes.favoritePageRoute,
            ),

            const Divider(height: 32, indent: 16, endIndent: 16),

            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              route: AppRoutes.settingsPageRoute,
            ),

            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              route: AppRoutes.aboutPageRoute,
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
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.secondary,
            child: const Icon(Icons.newspaper, color: Colors.white, size: 30),
          ),

          const SizedBox(height: 16),

          Text('Newspapers App', style: theme.textTheme.headlineSmall),

          const SizedBox(height: 4),

          Text('Your daily news', style: theme.textTheme.bodySmall),
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

          Navigator.of(context).pushReplacementNamed(route);
        },
      ),
    );
  }
}
