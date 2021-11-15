import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/utils/navigator_utils.dart';
import 'package:simple_todo_list/src/views/edit_todo_item_page/edit_todo_item_page.dart';
import 'package:simple_todo_list/src/views/home_page/done_todos_page/done_todos_page.dart';
import 'package:simple_todo_list/src/views/home_page/overdue_todos_page/overdue_todos_page.dart';
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

  _buildListTilesToDoGroups(ToDoItemsProvider toDoItemsProvider) {
    final int todayCount = toDoItemsProvider.todayItems.length;
    final int upcomingCount = toDoItemsProvider.upcomingItems.length;
    final int doneCount = toDoItemsProvider.doneItems.length;
    final int overdueCount = toDoItemsProvider.pastItems.length;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white
      ),
      margin: const EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
          children: [
            ListTile(
              onTap: () {
                NavigatorUtils.navigateToScreen(
                  context, const TodayToDosPage());
              },
              leading: Text('${DateTime.now().day}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Styles.upcomingTextColor)
                ),
              title: const Text('Today'),
              trailing: Text('$todayCount')
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              onTap: () {
                NavigatorUtils.navigateToScreen(
                  context, const UpcomingToDosPage());
              },
              leading: const Icon(CupertinoIcons.calendar_today,
                color: Styles.futureTextColor),
              title: const Text('Upcoming'),
              trailing: Text('$upcomingCount')
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              onTap: () {
                NavigatorUtils.navigateToScreen(
                  context, const DoneToDosPage());
              },
              leading: const Icon(CupertinoIcons.check_mark_circled,
                color: Colors.green),
              title: const Text('Done'),
              trailing: Text('$doneCount')
            ),
            const Divider(height: 1, thickness: 1),
            ListTile(
              onTap: () {
                NavigatorUtils.navigateToScreen(
                  context, const OverdueToDosPage());
              },
              leading: const Icon(Icons.timer, color: Styles.overdueTextColor),
              title: const Text('Overdue'),
              trailing: Text('$overdueCount')
            ),
          ]
        ),
    );                
  }


  @override
  Widget build(BuildContext context) {
    var toDoItemsProvider = context.watch<ToDoItemsProvider>();
    final List<ToDoItemModel> todayItems = toDoItemsProvider.todayItems;
    final List<ToDoItemModel> upcomingItems = toDoItemsProvider.upcomingItems;
    final List<ToDoItemModel> overdueItems = toDoItemsProvider.pastItems;
    final List<ToDoItemModel> doneItems = toDoItemsProvider.doneItems;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: TextField(
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: 'Search your todos ...',
            )
          ),
        ),
        actions: [
          IconButton(icon: const Icon(CupertinoIcons.arrow_2_circlepath),
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
          // PopupMenuButton(
          //   enableFeedback: true,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          //   child: const Icon(Icons.more_vert_rounded),
          //   itemBuilder: (context) {
          //     return const [
          //       PopupMenuItem(
          //         height: 32,
          //         padding: EdgeInsets.only(left: 14, top: 6, bottom: 6, right: 0),
          //         child: Text('Delete')
          //       )
          //     ];
          // }),
          const SizedBox(width: 8)
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
                _buildListTilesToDoGroups(toDoItemsProvider),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text('All To-Dos', style: Styles.sectionTitleNormal),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 16),
                      for (var toDoItem in overdueItems)
                        ToDoItemCard(toDoItem, key: UniqueKey()),
                      for (var toDoItem in todayItems)
                        ToDoItemCard(toDoItem, key: UniqueKey()),
                      for (var toDoItem in upcomingItems)
                        ToDoItemCard(toDoItem, key: UniqueKey()),
                      for (var toDoItem in doneItems)
                        ToDoItemCard(toDoItem, key: UniqueKey()),
                      const SizedBox(height: 48)
                    ]),
                  ),
                ),
              ]
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        disabledElevation: 0,
        child: const Icon(Icons.add_sharp, size: 40),
        onPressed: () {
          NavigatorUtils.navigateToScreen(context,
            EditToDoItemPage(ToDoItemModel.empty(), isNewItem: true));
        }
      )
    );
  }
}