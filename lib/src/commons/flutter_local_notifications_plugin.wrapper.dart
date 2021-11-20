
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:simple_todo_list/src/models/todo_item.model.dart';

class FlutterLocalNotificationsPluginWrapper {
  static FlutterLocalNotificationsPlugin? _instance;

  FlutterLocalNotificationsPluginWrapper._();

  static FlutterLocalNotificationsPlugin getInstance() {
    _instance ??= FlutterLocalNotificationsPlugin();

    return _instance!;
  }
  
  static final dateJmFormat = DateFormat('HH:mm - dd/MM/yyyy');

  static Future<void> zonedScheduleNotification(ToDoItemModel toDoItem) async {
    var rng = Random();
    await _instance!.zonedSchedule(
        rng.nextInt(200),
        toDoItem.title,
        dateJmFormat.format(toDoItem.occurTime),
        tz.TZDateTime.from(toDoItem.occurTime, tz.local)
            .subtract(const Duration(minutes: 10)),
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
        // payload: _toDoModel.toJsonString(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}