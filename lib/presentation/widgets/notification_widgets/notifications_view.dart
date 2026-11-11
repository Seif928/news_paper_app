import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/service/service_locator.dart'
    as service_locator;
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';
import 'package:news_paper_app/presentation/cubits/notification/notification_cubit.dart';
import 'package:news_paper_app/presentation/cubits/notification/notification_state.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/empty_state.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/notification_card.dart';
import 'package:news_paper_app/presentation/widgets/notification_widgets/section_label.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_page_scaffold.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => service_locator.sl<NotificationsCubit>()..loadNotifications(),
      child: const _NotificationsViewBody(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => service_locator.sl<NotificationsCubit>()..loadNotifications(),
      child: const _NotificationsViewBody(),
    );
  }
}

class _NotificationsViewBody extends StatelessWidget {
  const _NotificationsViewBody();

  @override
  Widget build(BuildContext context) {
    context.locale;

    final markAllReadButton = BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final hasUnread =
            state is NotificationsLoaded &&
            state.notifications.any((n) => !n.isRead);
        if (!hasUnread) return const SizedBox.shrink();
        return TextButton(
          onPressed:
              () => context.read<NotificationsCubit>().markAllAsRead(),
          child: Text(
            "Mark all read".tr(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        );
      },
    );

    return ResponsivePageScaffold(
      showDrawer: false,
      compactTitle: Text("Notifications".tr()),
      compactActions: [
        markAllReadButton,
        const SizedBox(width: 8),
      ],
      wideTitle: Text("Notifications".tr()),
      wideActions: [markAllReadButton],
      maxWidth: LayoutSizes.maxListWidth,
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading ||
              state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsError) {
            return Center(child: Text(state.message));
          }

          final notifications = (state as NotificationsLoaded).notifications;

          if (notifications.isEmpty) {
            return const EmptyState();
          }

          final today = <NotificationItem>[];
          final earlier = <NotificationItem>[];
          final now = DateTime.now();

          for (final n in notifications) {
            final isToday =
                n.time.year == now.year &&
                n.time.month == now.month &&
                n.time.day == now.day;
            (isToday ? today : earlier).add(n);
          }

          return Center(
            child: ResponsiveContent(
              maxWidth: LayoutSizes.maxListWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (today.isNotEmpty) ...[
                    SectionLabel(label: "Today".tr()),
                    const SizedBox(height: 8),
                    NotificationsCard(
                      items: today,
                      onTap:
                          (id) =>
                              context.read<NotificationsCubit>().markAsRead(id),
                      onDismiss:
                          (id) => context.read<NotificationsCubit>().dismiss(id),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (earlier.isNotEmpty) ...[
                    SectionLabel(label: "Earlier".tr()),
                    const SizedBox(height: 8),
                    NotificationsCard(
                      items: earlier,
                      onTap:
                          (id) =>
                              context.read<NotificationsCubit>().markAsRead(id),
                      onDismiss:
                          (id) => context.read<NotificationsCubit>().dismiss(id),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}