import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../data/static_data.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    loadNotifications();
  }

  void loadNotifications() {
    _isLoading = true;
    notifyListeners();

    _notifications = List<NotificationModel>.from(StaticData.notifications);
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void addNotification({
    required String title,
    required String description,
    String? proposalId,
  }) {
    final newNotification = NotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      proposalId: proposalId,
      timestamp: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, newNotification);
    notifyListeners();
  }
}