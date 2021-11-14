import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_todo_list/src/simple_todo_list_app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todoItems');
  runApp(const SimpleToDoListApp());
}