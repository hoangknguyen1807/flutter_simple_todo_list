import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';

class EditToDoItemPage extends StatefulWidget {
  const EditToDoItemPage(this.toDoModel, {this.isNewItem = false, Key? key }) : super(key: key);

  final ToDoItemModel toDoModel;
  final bool isNewItem;

  @override
  _EditToDoItemPageState createState() => _EditToDoItemPageState();
}

class _EditToDoItemPageState extends State<EditToDoItemPage> {

  final dateFormat = DateFormat('EEE yyyy-MM-dd');
  final timeFormat = DateFormat.jm();

  late ToDoItemModel _toDoModel;

  late TextEditingController _titleController;

  late TextEditingController _descriptionController;

  late TextEditingController _dateController;

  late DateTime _selectedDate;

  late TextEditingController _timeController;

  late TimeOfDay _selectedTime;

  late bool _isItemDone;

  void _selectDate() async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        buildMaterialDatePicker(context);
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        buildCupertinoDatePicker(context);
        break;
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (newDate != null && newDate != _selectedDate) {
      setState(() => _selectedDate = newDate);
    }
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) async {
    DateTime newDate = _selectedDate;

    bool? result = await showCupertinoModalPopup<bool>(
        context: context,
        builder: (BuildContext builder) {
          return CupertinoActionSheet(
            actions: [ 
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: CupertinoDatePicker(
                  dateOrder: DatePickerDateOrder.ymd,
                  use24hFormat: true,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) => newDate = value,
                  initialDateTime: newDate,
                  minimumYear: 2000,
                  maximumYear: 2030,
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Done'),
                isDefaultAction: true,
              ),
            ]
          );
        },
    );

    if (result == true) {
      setState(() {
        _selectedDate = newDate;
        _dateController.text = dateFormat.format(newDate);
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context, initialTime: _selectedTime);

    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        _timeController.text = newTime.format(context);
      });
    }
  }

  bool _itemHasNotChanged() {
    return _toDoModel.isDone == _isItemDone
        && _toDoModel.title == _titleController.text
        && _toDoModel.description == _descriptionController.text
        && DateUtils.isSameDay(_toDoModel.occurTime, _selectedDate)
        && _toDoModel.occurTime.hour == _selectedTime.hour
        && _toDoModel.occurTime.minute == _selectedTime.minute;
  }

  void _saveToDoItem() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Cannot save a task with empty title!', style: TextStyle(fontSize: 18)
            ))
        );
        return;
    }

    if (_itemHasNotChanged()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Nothing new to save.', style: TextStyle(fontSize: 18)
            ))
        );
        return;
    }

    _toDoModel.title = _titleController.text;
    _toDoModel.description = _descriptionController.text;
    _toDoModel.occurTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute
    );
    _toDoModel.isDone = _isItemDone;

    final toDoItemsProvider = context.read<ToDoItemsProvider>();
    if (widget.isNewItem) {
      toDoItemsProvider.add(_toDoModel);
      Navigator.of(context).pop();
    } else {
      toDoItemsProvider.saveToHive();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(
        'ToDo item saved!', style: TextStyle(fontSize: 18)
        ))
    );
  }

  void _deleteToDoItem() async {
    var result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              elevation: 2.0,
              title: const Text(
                  'Deleting ToDo item',
                  style: TextStyle(fontStyle: FontStyle.normal)),
              content: const Text(
                  "Are you sure you want to delete this ToDo?"),
              actions: [
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text('YES'),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.blue)
                  ),
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ));
    if (result == true) {
      final toDoItemsProvider = context.read<ToDoItemsProvider>();
      toDoItemsProvider.remove(_toDoModel);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'ToDo item deleted!', style: TextStyle(fontSize: 18)
          ))
      );
    }
  }

  Future<bool> _onLeaving() async {
    if (_itemHasNotChanged()) {
      return true;
    }
    var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 2.0,
              title: const Text(
                  'Discard changes',
                  style: TextStyle(fontStyle: FontStyle.normal)),
              content: const Text(
                  "Leaving now will discard your changes. Still leave?"),
              actions: [
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text('YES'),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            ));
    return result == true;
  }

  @override
  void initState() {
    _toDoModel = widget.toDoModel;
    _titleController = TextEditingController
                        .fromValue(TextEditingValue(text: _toDoModel.title));
    _descriptionController = TextEditingController
                        .fromValue(TextEditingValue(text: _toDoModel.description));
    _dateController = TextEditingController.fromValue(
            TextEditingValue(text: dateFormat.format(_toDoModel.occurTime)));
    _selectedDate = _toDoModel.occurTime;
    _timeController = TextEditingController.fromValue(
            TextEditingValue(text: timeFormat.format(_selectedDate)));
    _selectedTime = TimeOfDay.fromDateTime(_toDoModel.occurTime);
    _isItemDone = _toDoModel.isDone;
    
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onLeaving,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: widget.isNewItem ? const Text('New ToDo') : null,
          actions: [
            IconButton(onPressed: _saveToDoItem,
              icon: const Icon(CupertinoIcons.floppy_disk, size: 26)),
            if (!widget.isNewItem)
              IconButton(onPressed: _deleteToDoItem,
                icon: const Icon(CupertinoIcons.delete_solid)),
            const SizedBox(width: 4)
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Checkbox(value: _isItemDone, onChanged: (newValue) {
                    setState(() => _isItemDone = (newValue == true));
                  }),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      cursorColor: Colors.blue,
                      controller: _titleController,        
                      style: TextStyle(fontSize: 20,
                        decoration: (_isItemDone) ? TextDecoration.lineThrough: null,
                        decorationStyle: TextDecorationStyle.double
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onTap: _selectDate,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(CupertinoIcons.calendar, size: 26)
              ),
              readOnly: true,
              controller: _dateController,
            ),
            TextField(
              onTap: _selectTime,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(CupertinoIcons.time, size: 26)
              ),
              readOnly: true,
              controller: _timeController,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 30,
              minLines: 12,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Description',
                hintStyle: TextStyle(fontSize: 16),
              ),
              cursorColor: Colors.blue,
              controller: _descriptionController,        
              style: const TextStyle(fontSize: 16),
            ),
          ]),
        ),
      ),
    );
  }
}