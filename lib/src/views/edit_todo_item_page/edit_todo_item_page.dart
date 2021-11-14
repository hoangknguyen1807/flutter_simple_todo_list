import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';

class EditToDoItemPage extends StatefulWidget {
  const EditToDoItemPage(this.toDoModel, { Key? key }) : super(key: key);

  final ToDoItemModel toDoModel;

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

  void _saveToDoItem() {
    if (_toDoModel.title == _titleController.text
        && _toDoModel.description == _descriptionController.text
        && DateUtils.isSameDay(_toDoModel.occurTime, _selectedDate)
        && _toDoModel.occurTime.hour == _selectedTime.hour
        && _toDoModel.occurTime.minute == _selectedTime.minute) {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(
        'ToDo item saved!', style: TextStyle(fontSize: 18)
        ))
    );
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
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(onPressed: _saveToDoItem,
            icon: const Icon(CupertinoIcons.floppy_disk, size: 26)),
          const SizedBox(width: 4)
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: 'Title',
              hintStyle: TextStyle(fontSize: 20),
            ),
            cursorColor: Colors.blue,
            controller: _titleController,        
            style: const TextStyle(fontSize: 20),
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
    );
  }
}