import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/service/notification_storage_service.dart';
import 'package:news_paper_app/domain/entities/notification_item.dart';
import 'package:news_paper_app/presentation/cubits/notification/notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._storage) : super(NotificationsInitial());

  final NotificationStorageService _storage;

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final items = await _storage.getAll();
      emit(NotificationsLoaded(items));
    } catch (_) {
      emit(const NotificationsError('Failed to load notifications.'));
    }
  }

  Future<void> markAsRead(String id) async {
    await _storage.markAsRead(id);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await _storage.markAllAsRead();
    await loadNotifications();
  }

  Future<void> dismiss(String id) async {
    await _storage.dismiss(id);
    await loadNotifications();
  }

  Future<void> addNotification(NotificationItem item) async {
    await _storage.add(item);
    await loadNotifications();
  }
}
