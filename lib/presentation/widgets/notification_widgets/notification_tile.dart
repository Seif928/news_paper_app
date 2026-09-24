import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.item,
    required this.isLast,
    required this.onTap,
    required this.onDismiss,
  });

  IconData get _icon {
    switch (item.type) {
      case NotificationType.breakingNews:
        return Icons.bolt;
      case NotificationType.article:
        return Icons.article_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  String _timeLabel(BuildContext context) {
    final diff = DateTime.now().difference(item.time);
    if (diff.inMinutes < 60) {
      return context.locale.languageCode == 'ar'
          ? (diff.inMinutes <= 1
              ? 'منذ دقيقة'
              : diff.inMinutes == 2
              ? 'منذ دقيقتين'
              : (diff.inMinutes >= 3 && diff.inMinutes <= 10)
              ? 'منذ ${diff.inMinutes}دقائق'
              : 'منذ ${diff.inMinutes} دقيقة')
          : '${diff.inMinutes}m ago ';
    }
    if (diff.inHours < 24) {
      return context.locale.languageCode == 'ar'
          ? (diff.inHours <= 1
              ? 'منذ ساعة'
              : diff.inHours == 2
              ? 'منذ ساعتين'
              : (diff.inHours >= 3 && diff.inHours <= 10)
              ? 'منذ ${diff.inHours} ساعات'
              : 'منذ ${diff.inHours} ساعة')
          : '${diff.inHours}h ago ';
    }
    return context.locale.languageCode == 'ar'
        ? (diff.inDays <= 1
            ? 'منذ يوم'
            : diff.inDays == 2
            ? 'منذ يومين'
            : 'منذ ${diff.inDays}ايام')
        : '${diff.inDays}d ago ';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border:
                isLast
                    ? null
                    : Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.6,
                      ),
                    ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              fontWeight:
                                  item.isRead
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeLabel(context),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
