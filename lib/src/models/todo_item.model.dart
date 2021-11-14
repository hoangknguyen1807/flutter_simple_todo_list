import 'package:hive/hive.dart';

part 'todo_item.model.g.dart';

@HiveType(typeId: 1)
class ToDoItemModel {

  @HiveField(0)
  String _title;

  @HiveField(1)
  DateTime _occurTime;
  
  @HiveField(2)
  String _description;
  
  @HiveField(3)
  bool _isDone;

  ToDoItemModel.empty() :
    _title = '',
    _occurTime = DateTime.now(),
    _description = '',
    _isDone = false;

  ToDoItemModel(
    this._title, this._occurTime,
    [ this._isDone = false, this._description = '' ]);

  String get title => _title;

  set title(String title) {
    _title = title;
  }

  String get description => _description;

  set description(String description) {
    _description = description;
  }

  DateTime get occurTime => _occurTime;

  set occurTime(DateTime occurTime) {
    _occurTime = occurTime;
  }
  
  bool get isDone => _isDone;

  set isDone(bool isDone) {
    _isDone = isDone;
  }

  bool isOverdue() => occurTime.isBefore(DateTime.now()) && !_isDone;
}