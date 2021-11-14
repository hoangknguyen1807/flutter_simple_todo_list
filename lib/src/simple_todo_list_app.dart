import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'models/todo_item.model.dart';
import 'views/home_page/home_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './commons/constants.dart' as constants;


class SimpleToDoListApp extends StatefulWidget {
  const SimpleToDoListApp({ Key? key }) : super(key: key);

  @override
  _SimpleToDoListAppState createState() => _SimpleToDoListAppState();
}

class _SimpleToDoListAppState extends State<SimpleToDoListApp> {
  
  final List<ToDoItemModel> myMockItems = List.unmodifiable([
    ToDoItemModel('Go to sleep', DateTime(2021, 11, 13, 22), true),
    ToDoItemModel('English class', DateTime(2021, 11, 16, 14, 0), false, 'Learn on Zoom'),
    ToDoItemModel('Write paper', DateTime(2021, 11, 15, 21)),
    ToDoItemModel('Exercise', DateTime(2021, 11, 15, 17, 30)),
    ToDoItemModel('Read book', DateTime(2021, 11, 14, 19, 0)),
    ToDoItemModel('Read book', DateTime(2021, 11, 18, 19, 0)),
    ToDoItemModel('Read book', DateTime(2021, 11, 19, 19, 0))
  ]);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]
    );

    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('todosBox').listenable(),
      builder: (context, box, widget) {
        List<dynamic> allStoredItems = box.get(constants.todoItemsKey,
          defaultValue: <ToDoItemModel>[]);

        return ChangeNotifierProvider(
          create: (context) => 
                    ToDoItemsProvider(allStoredItems.cast<ToDoItemModel>()),
          child: MaterialApp(
            title: 'Simple ToDo List App',
            theme: ThemeData(
              scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
              primarySwatch: Colors.green,
            ),
            home: const HomePage(),
          ),
        );
      }
    );
  }
}