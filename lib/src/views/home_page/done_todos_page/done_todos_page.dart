import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/views/widgets/has_searchbox_in_appbar.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';
import 'package:provider/provider.dart';

class DoneToDosPage extends StatefulWidget {
  const DoneToDosPage({ Key? key }) : super(key: key);

  @override
  _DoneToDosPageState createState() => _DoneToDosPageState();
}

class _DoneToDosPageState extends State<DoneToDosPage>
  with HasSearchBoxInAppBar {

  final dateFormat = DateFormat.yMMMEd();

  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    final doneItems = toDoItemsProvider.doneItems;

    return Scaffold(
      appBar: AppBar(
        title: (!isSearching) ? const Text('Done')
          : buildSearchBoxAppBar(onChanged: (value) {
              updateSearchResult(value,
                    context.read<ToDoItemsProvider>().doneItems);
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
              child: Text("Did you miss anything? If not, then well done!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor)),
            ),
            const Divider(thickness: 1, height: 2),
            Container(
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var toDoItem in doneItems)
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