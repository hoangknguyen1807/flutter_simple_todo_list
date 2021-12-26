import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_todo_list/src/commons/constants.dart' as constants;
import 'package:simple_todo_list/src/simple_todo_list_app.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/models/local_notification/local_notification.model.dart';
import 'src/models/todo_item/todo_item.model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureLocalTimeZone();

  Hive.registerAdapter(ToDoItemModelAdapter());
  Hive.registerAdapter(LocalNotificationModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox(constants.todosBoxName);
  runApp(const SimpleToDoListApp());
}

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
