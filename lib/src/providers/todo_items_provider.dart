import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:simple_todo_list/src/commons/constants.dart' as constants;
import 'package:simple_todo_list/src/models/todo_item.model.dart';

class ToDoItemsProvider extends ChangeNotifier {

  late Box _box;

  List<ToDoItemModel> _allItems = [];
  final List<ToDoItemModel> _todayItems = [];
  final List<ToDoItemModel> _pastItems = [];
  final List<ToDoItemModel> _upcomingItems = [];
  final List<ToDoItemModel> _doneItems = [];

  ToDoItemsProvider(List<ToDoItemModel> allStoredItems) {    
    _box = Hive.box(constants.todosBoxName);
    _allItems.addAll(allStoredItems);
    update();
  }

  int _comparator(ToDoItemModel a, ToDoItemModel b) {
    return a.occurTime.compareTo(b.occurTime);
  }

  List<ToDoItemModel> get allItems => _allItems;

  set allItems(List<ToDoItemModel> allItems) {
    _allItems = allItems;
    notifyListeners();
  }

  void add(ToDoItemModel item) {
    _allItems.add(item);
    saveToHive();
  }

  void remove(ToDoItemModel item) {
    _allItems.remove(item);
    saveToHive();
  }

  void update() {
    _allItems.sort(_comparator);

    _todayItems.clear();
    _doneItems.clear();
    _pastItems.clear();
    _upcomingItems.clear();

    final today = DateTime.now();
    for (var item in _allItems) {
      if (item.isDone) {
        _doneItems.add(item);
      } else if (DateUtils.isSameDay(item.occurTime, today)) {
        _todayItems.add(item);
      } else {
        if (item.occurTime.isAfter(today)) {
          _upcomingItems.add(item);
        } else {
          _pastItems.add(item);
        }
      }
    }

    notifyListeners();
  }

  void saveToHive() {
    update();
    _box.put(constants.todoItemsKey, allItems);
  }

  List<ToDoItemModel> get todayItems => _todayItems;

  List<ToDoItemModel> get pastItems => _pastItems;

  List<ToDoItemModel> get upcomingItems => _upcomingItems;

  List<ToDoItemModel> get doneItems => _doneItems;

}