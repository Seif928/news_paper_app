import 'package:flutter/material.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/notification_tile.dart';

class NotificationsCard extends StatelessWidget {
  final List<NotificationItem> items;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onDismiss;

  const NotificationsCard({
    super.key,
    required this.items,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            NotificationTile(
              item: items[i],
              isLast: i == items.length - 1,
              onTap: () => onTap(items[i].id),
              onDismiss: () => onDismiss(items[i].id),
            ),
        ],
      ),
    );
  }
}
