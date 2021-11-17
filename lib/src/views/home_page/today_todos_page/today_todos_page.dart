import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/views/widgets/has_searchbox_in_appbar.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';
import 'package:provider/provider.dart';

class TodayToDosPage extends StatefulWidget {
  const TodayToDosPage({ Key? key }) : super(key: key);

  @override
  _TodayToDosPageState createState() => _TodayToDosPageState();
}

class _TodayToDosPageState extends State<TodayToDosPage>
  with HasSearchBoxInAppBar {

  final dateFormat = DateFormat.yMMMEd();
  final today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    var todayItems = toDoItemsProvider.todayItems;

    return Scaffold(
      appBar: AppBar(
        title: (!isSearching) ? const Text('Today')
          : buildSearchBoxAppBar(onChanged: (value) {
              updateSearchResult(value,
                  context.read<ToDoItemsProvider>().todayItems);
              setState(() => query = value);
          }),
        actions: [
          buildSearchIconButton(onPressed: () {
            setState(() => toggleSearch());
          })
        ],
      ),
      body: SafeArea(
        child: (query.isNotEmpty)
        ? buildSearchToDoResult()
        : Column(
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
                    for (var toDoItem in todayItems)
                      ToDoItemCard(toDoItem, key: UniqueKey())
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