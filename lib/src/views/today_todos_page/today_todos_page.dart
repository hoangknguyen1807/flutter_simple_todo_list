import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';

class TodayToDosPage extends StatefulWidget {
  const TodayToDosPage({ Key? key }) : super(key: key);

  @override
  _TodayToDosPageState createState() => _TodayToDosPageState();
}

class _TodayToDosPageState extends State<TodayToDosPage> {

  final dateFormat = DateFormat.yMMMEd();
  final today = DateTime.now();

   final todayToDoItems = [
    ToDoItemModel('Exercise', DateTime(2021, 11, 14, 17, 30)),
    ToDoItemModel('Read book', DateTime(2021, 11, 14, 19, 0))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search, size: 24),
            onPressed: () {
            },),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white54,
              child: Text(dateFormat.format(today),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  color: Styles.upcomingTextColor)),
            ),
            const Divider(thickness: 1, height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var toDoItem in todayToDoItems)
                    ToDoItemCard(toDoItem)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}