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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.onSurface),
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
