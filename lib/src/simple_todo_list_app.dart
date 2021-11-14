import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/views/today_todos_page/today_todos_page.dart';

import 'views/home_page/home_page.dart';


class SimpleToDoListApp extends StatefulWidget {
  const SimpleToDoListApp({ Key? key }) : super(key: key);

  @override
  _SimpleToDoListAppState createState() => _SimpleToDoListAppState();
}

class _SimpleToDoListAppState extends State<SimpleToDoListApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]
    );

    return MaterialApp(
      title: 'Simple ToDo List App',
      theme: ThemeData(
        scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (_) => const HomePage(),
        '/today': (_) => const TodayToDosPage(),
      },
    );
  }
}