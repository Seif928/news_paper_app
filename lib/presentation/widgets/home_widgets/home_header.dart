import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            );
          },
        ),

        Expanded(
          child: Center(
            child: Text(
              "Al Akhbar".tr(),
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.notificationPageRoute),
            icon: const Icon(Icons.notifications_none),
          ),
        ),
      ],
    );
  }
}
