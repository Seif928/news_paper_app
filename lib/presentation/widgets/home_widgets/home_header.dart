import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/responsive.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = Responsive.of(context);

    if (size.isCompact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
                tooltip: 'Menu',
              );
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                "Al Akhbar".tr(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.notificationPageRoute),
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifications'.tr(),
          ),
        ],
      );
    }

    // Tablet & Desktop Header: Clean, balanced branding with direct search access
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Al Akhbar".tr(),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Your daily news".tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: size.isLarge ? 360 : 280,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.searchPageRoute, arguments: true);
            },
            child: IgnorePointer(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Search news, topics, or sources...".tr(),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton.filledTonal(
          onPressed:
              () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.notificationPageRoute),
          icon: const Icon(Icons.notifications_none),
          tooltip: 'Notifications'.tr(),
        ),
      ],
    );
  }
}
