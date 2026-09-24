import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 56,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 16),
            Text(
              "No notifications yet".tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll let you know when something new comes up.".tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
