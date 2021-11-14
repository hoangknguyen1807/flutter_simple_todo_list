import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';
import 'package:provider/provider.dart';

class TodayToDosPage extends StatefulWidget {
  const TodayToDosPage({ Key? key }) : super(key: key);

  @override
  _TodayToDosPageState createState() => _TodayToDosPageState();
}

class _TodayToDosPageState extends State<TodayToDosPage> {

  final dateFormat = DateFormat.yMMMEd();
  final today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    var todayItems = toDoItemsProvider.todayItems;

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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor)),
            ),
            const Divider(thickness: 1, height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var toDoItem in todayItems)
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