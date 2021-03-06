import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/views/widgets/has_searchbox_in_appbar.mixin.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';
import 'package:provider/provider.dart';

class UpcomingToDosPage extends StatefulWidget {
  const UpcomingToDosPage({ Key? key }) : super(key: key);

  @override
  _UpcomingToDosPageState createState() => _UpcomingToDosPageState();
}

class _UpcomingToDosPageState extends State<UpcomingToDosPage>
  with HasSearchBoxInAppBar {

  final dateFormat = DateFormat.yMMMEd();

  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    var upcomingItems = toDoItemsProvider.upcomingItems;

    return Scaffold(
      appBar: AppBar(
        title: (!isSearching) ? const Text('Upcoming')
        : buildSearchBoxAppBar(onChanged: (value) {
            updateSearchResult(value,
                context.read<ToDoItemsProvider>().upcomingItems);
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
              child: const Text("Be ahead of the schedule?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  color: Styles.futureTextColor)),
            ),
            const Divider(thickness: 1, height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var toDoItem in upcomingItems)
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