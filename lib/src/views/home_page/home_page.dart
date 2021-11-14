import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/utils/navigator_utils.dart';
import 'package:simple_todo_list/src/views/home_page/done_todos_page/done_todos_page.dart';
import 'package:simple_todo_list/src/views/home_page/upcoming_todos_page/upcoming_todos_page.dart';

import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';

import 'today_todos_page/today_todos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    List<ToDoItemModel> allToDoItems = toDoItemsProvider.allItems;

    final int todayCount = toDoItemsProvider.todayItems.length;
    final int upcomingCount = toDoItemsProvider.upcomingItems.length;
    final int doneCount = toDoItemsProvider.doneItems.length; 

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: TextField(
            style: TextStyle(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Search your todos ...',
            )
          ),
        ),
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.refresh_thick),
            onPressed: () {
              _isLoading = true;
              context.read<ToDoItemsProvider>().update();
              Future.delayed(const Duration(milliseconds: 750), () {
                setState(() => _isLoading = false);
              });
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.bell, size: 28)
          ),
          const SizedBox(width: 6)
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: (_isLoading)
          ? const Center(
              child: SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 6.0,
                ),
              ),
          )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          onTap: () {
                            NavigatorUtils.navigateToScreen(
                              context, const TodayToDosPage());
                          },
                          leading: Text('${DateTime.now().day}',
                            style: const TextStyle(fontSize: 20)),
                          title: const Text('Today'),
                          trailing: Text('$todayCount')
                        ),
                        const Divider(height: 1, thickness: 1),
                        ListTile(
                          onTap: () {
                            NavigatorUtils.navigateToScreen(
                              context, const UpcomingToDosPage());
                          },
                          leading: const Icon(CupertinoIcons.calendar_today),
                          title: const Text('Upcoming'),
                          trailing: Text('$upcomingCount')
                        ),
                        const Divider(height: 1, thickness: 1),
                        ListTile(
                          onTap: () {
                            NavigatorUtils.navigateToScreen(
                              context, const DoneToDosPage());
                          },
                          leading: const Icon(CupertinoIcons.check_mark_circled),
                          title: const Text('Done'),
                          trailing: Text('$doneCount')
                        ),
                      ]
                    ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('All To-Dos', style: Styles.sectionTitleNormal),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 16),
                      for (var toDoItem in allToDoItems)
                      ToDoItemCard(toDoItem),
                    ]),
                  ),
                ),
              ]
            ),
        ),
      )
    );
  }
}