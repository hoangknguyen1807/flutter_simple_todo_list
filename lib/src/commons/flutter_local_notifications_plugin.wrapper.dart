
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:simple_todo_list/src/models/local_notification/local_notification.model.dart';
import 'package:simple_todo_list/src/providers/notifications_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:simple_todo_list/src/models/todo_item/todo_item.model.dart';

class FlutterLocalNotificationsPluginWrapper {
  static FlutterLocalNotificationsPlugin? _instance;

  static BehaviorSubject<String?>? _notificationSubject;

  FlutterLocalNotificationsPluginWrapper._();

  static FlutterLocalNotificationsPlugin getPluginInstance() {
    _instance ??= FlutterLocalNotificationsPlugin();

    return _instance!;
  }

  static BehaviorSubject<String?> getNotificationSubject() {
    _notificationSubject ??= BehaviorSubject<String?>();

    return _notificationSubject!;
  }
  
  static final dateJmFormat = DateFormat('HH:mm - dd/MM/yyyy');

  static Future<void> zonedScheduleNotification(
    ToDoItemModel toDoItem, NotificationsProvider notiProvider) async {
    var rng = Random();
    final id = rng.nextInt(1000);
    final scheduledTime = tz.TZDateTime.from(toDoItem.occurTime, tz.local)
            .subtract(const Duration(minutes: 10));
    final payload = id.toString();

    notiProvider.add(LocalNotificationModel(
      id: id,
      title: toDoItem.title,
      body: dateJmFormat.format(toDoItem.occurTime),
      scheduledTime: scheduledTime
    ));

    await _instance!.zonedSchedule(
        id,
        toDoItem.title,
        dateJmFormat.format(toDoItem.occurTime),
        scheduledTime,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
              ),
            iOS: IOSNotificationDetails(threadIdentifier: 'simple_todo_app') 
        ),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}