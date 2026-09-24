// presentation/views/notifications_view.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/empty_state.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/notification_card.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/section_label.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  // Dummy data — replace with data from a NotificationsCubit
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Breaking: Market hits record high',
      body: 'Stocks surged today as investors reacted to the latest report.',
      time: DateTime.now().subtract(const Duration(minutes: 12)),
      type: NotificationType.breakingNews,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'New article from your saved topic',
      body: 'Technology: The rise of on-device AI in 2026.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.article,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Weekly digest is ready',
      body: 'Catch up on the top 10 stories you may have missed.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      type: NotificationType.system,
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _dismiss(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    final today = <NotificationItem>[];
    final earlier = <NotificationItem>[];
    final now = DateTime.now();

    for (final n in _notifications) {
      final isToday =
          n.time.year == now.year &&
          n.time.month == now.month &&
          n.time.day == now.day;
      (isToday ? today : earlier).add(n);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Notifications".tr(),
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                "Mark all read".tr(),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child:
            _notifications.isEmpty
                ? const EmptyState()
                : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 8),
                    if (today.isNotEmpty) ...[
                      SectionLabel(label: "Today".tr()),
                      const SizedBox(height: 8),
                      NotificationsCard(
                        items: today,
                        onTap: _markAsRead,
                        onDismiss: _dismiss,
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (earlier.isNotEmpty) ...[
                      SectionLabel(label: "Earlier".tr()),
                      const SizedBox(height: 8),
                      NotificationsCard(
                        items: earlier,
                        onTap: _markAsRead,
                        onDismiss: _dismiss,
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
      ),
    );
  }
}
