import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/commons/flutter_local_notifications_plugin.wrapper.dart';
import 'package:simple_todo_list/src/models/local_notification/local_notification.model.dart';
import 'package:simple_todo_list/src/providers/notifications_provider.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/utils/navigator_utils.dart';
import 'models/todo_item/todo_item.model.dart';
import 'views/home_page/home_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './commons/constants.dart' as constants;

class SimpleToDoListApp extends StatefulWidget {
  const SimpleToDoListApp({ Key? key }) : super(key: key);

  @override
  _SimpleToDoListAppState createState() => _SimpleToDoListAppState();
}

class _SimpleToDoListAppState extends State<SimpleToDoListApp> {

  final List<ToDoItemModel> myMockItems = List.unmodifiable([
    ToDoItemModel('Go to sleep', DateTime(2021, 11, 13, 22), true),
    ToDoItemModel('English class', DateTime(2021, 11, 16, 14, 0), false, 'Learn on Zoom'),
    ToDoItemModel('Write paper', DateTime(2021, 11, 15, 21)),
    ToDoItemModel('Exercise', DateTime(2021, 11, 15, 17, 30)),
    ToDoItemModel('Read book', DateTime(2021, 11, 14, 19, 0)),
    ToDoItemModel('Read book', DateTime(2021, 11, 18, 19, 0)),
    ToDoItemModel('Go jogging', DateTime(2021, 11, 19, 6, 0))
  ]);

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _getNotificationAppLaunchDetails() async {    
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      (kIsWeb || Platform.isLinux)
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final payload = notificationAppLaunchDetails!.payload;
      debugPrint(payload);
      FlutterLocalNotificationsPluginWrapper.getNotificationSubject().add(payload);
    }
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPluginWrapper.getPluginInstance();

    _getNotificationAppLaunchDetails();

    // initialize the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
      );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _selectNotification
    );

    super.initState();
  }

  void _selectNotification(String? payload) {
    debugPrint('notification payload: $payload');
    FlutterLocalNotificationsPluginWrapper.getNotificationSubject().add(payload);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]
    );

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(constants.todosBoxName).listenable(),
      builder: (context, box, widget) {
        List<dynamic> allStoredItems = box.get(constants.todoItemsKey,
          defaultValue: <ToDoItemModel>[]);
        List<dynamic> allStoredNotifications = box.get(constants.notificationsKey,
          defaultValue: <LocalNotificationModel>[]);

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => 
              ToDoItemsProvider(allStoredItems.cast<ToDoItemModel>())),
            ChangeNotifierProvider(create: (context) => 
              NotificationsProvider(allStoredNotifications.cast<LocalNotificationModel>()))
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Simple ToDo List',
            theme: ThemeData(
              scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
              primarySwatch: Colors.green,
            ),
            home: const HomePage(),
          ),
        );
      }
    );
  }
}