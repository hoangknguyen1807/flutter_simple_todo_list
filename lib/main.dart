import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_todo_list/src/commons/constants.dart' as constants;
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/simple_todo_list_app.dart';

void main() async {
  Hive.registerAdapter(ToDoItemModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox(constants.todosBoxName);
  runApp(const SimpleToDoListApp());
}