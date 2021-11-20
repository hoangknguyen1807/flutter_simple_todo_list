import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_list/src/themes/styles.dart';

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({ Key? key }) : super(key: key);

  @override
  _NotificationsSheetState createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).copyWith().size.height * 0.75,
      child: Column(children: [
          AppBar(
            toolbarHeight: 64,
            titleTextStyle: Theme.of(context).textTheme.headline6!
              .copyWith(color: Colors.green),
            backgroundColor: Theme.of(context).dialogBackgroundColor
              .withOpacity(0.5),
            iconTheme: Theme.of(context).iconTheme
              .copyWith(color: Colors.green),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)
              ),
            ),
            elevation: 0,
            title: const Text('Notifications'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.done_all))
            ]
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    style: true
                      ? Styles.activeTextButtonStyle
                      : Styles.inactiveTextButtonStyle,
                    onPressed: (){}, child: const Text('All')),
                ),
                Expanded(
                  child: TextButton(
                    style: false
                      ? Styles.inactiveTextButtonStyle
                      : Styles.activeTextButtonStyle,
                    onPressed: (){}, child: const Text('Unread')
                  )
                )
              ],
            ),
          ),
        ]),
    );
  }
}