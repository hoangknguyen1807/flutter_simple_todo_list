import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/views/widgets/todo_item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final nowDate = DateTime.now();

  final allToDoItems = [
    ToDoItemModel('Go to sleep', DateTime(2021, 11, 13, 22), true),
    ToDoItemModel('English class', DateTime(2021, 11, 16, 14, 0), false, 'Learn on Zoom'),
    ToDoItemModel('Exercise', DateTime(2021, 11, 15, 17, 30)),
    ToDoItemModel('Exercise', DateTime(2021, 11, 15, 17, 30)),
    ToDoItemModel('Read book', DateTime(2021, 11, 14, 19, 0))
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                            Navigator.of(context).pushNamed('/today');
                          },
                          leading: Text('${nowDate.day}',
                            style: TextStyle(fontSize: 20)),
                          title: Text('Today'),
                          trailing: Text('2')
                        ),
                        const Divider(height: 1, thickness: 1),
                        ListTile(
                          onTap: () {},
                          leading: Icon(CupertinoIcons.calendar_today),
                          title: Text('Upcoming'),
                          trailing: Text('2')
                        ),
                        const Divider(height: 1, thickness: 1),
                        ListTile(
                          onTap: () {},
                          leading: Icon(CupertinoIcons.check_mark_circled),
                          title: Text('Done'),
                          trailing: Text('4')
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