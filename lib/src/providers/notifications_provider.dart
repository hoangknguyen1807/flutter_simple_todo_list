import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:simple_todo_list/src/models/local_notification/local_notification.model.dart';
import 'package:simple_todo_list/src/commons/constants.dart' as constants;

class NotificationsProvider extends ChangeNotifier {

  late Box _box;

  final List<LocalNotificationModel> _notifications = [];

  NotificationsProvider(List<LocalNotificationModel> storedNotifications) {
    _box = Hive.box(constants.todosBoxName);
    _notifications.addAll(storedNotifications);
  }

  List<LocalNotificationModel> get allNotifications => _notifications;

  List<LocalNotificationModel> get receivedNotifications =>
    _notifications.where((n) => !n.scheduledTime.isAfter(DateTime.now())).toList();

  List<LocalNotificationModel> get unreadNotifications =>
    receivedNotifications.where((n) => !n.isRead).toList();

  void refresh() {
    notifyListeners();
  }

  void markAllAsRead() {
    for (var e in _notifications) {
      e.isRead = true;
    }
    saveToHive();
  }

  void add(LocalNotificationModel notification) {
    _notifications.insert(0, notification);
    saveToHive();
  }

  void remove(LocalNotificationModel notification) {
    _notifications.remove(notification);
    saveToHive();
  }

  void removeAll() {
    _notifications.clear();
    saveToHive();
  }

  void saveToHive() {
    refresh();
    _box.put(constants.notificationsKey, _notifications);
  }
}