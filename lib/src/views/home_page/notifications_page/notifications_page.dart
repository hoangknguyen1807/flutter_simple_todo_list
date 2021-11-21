import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_list/src/providers/notifications_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/views/widgets/notification_item_card.dart';

class NotificationsSheet extends StatefulWidget {
  const NotificationsSheet({ Key? key }) : super(key: key);

  @override
  _NotificationsSheetState createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {

  int _selectedTab = 0;

  void _deleteAll() {
    context.read<NotificationsProvider>().removeAll();
  }

  void _markAllAsRead() {
    context.read<NotificationsProvider>().markAllAsRead();
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = context.watch<NotificationsProvider>();
    final receivedNotifications = notificationProvider.receivedNotifications;
    final unreadNotifications = notificationProvider.unreadNotifications;

    return Container(
      height: MediaQuery.of(context).copyWith().size.height * 0.75,
      child: Column(children: [
          AppBar(
            toolbarHeight: 60,
            titleTextStyle: Theme.of(context).textTheme.headline6!
              .copyWith(color: Colors.green),
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            iconTheme: Theme.of(context).iconTheme
              .copyWith(color: Colors.green),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)
              ),
            ),
            elevation: 0,
            leading: IconButton(icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _deleteAll),
            title: const Text('Notifications'),
            actions: [
              IconButton(icon: const Icon(Icons.done_all),
              onPressed: _markAllAsRead)
            ]
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey[50]!.withOpacity(0.4),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: _selectedTab == 0
                            ? Styles.activeTextButtonStyle
                            : Styles.inactiveTextButtonStyle,
                          onPressed: () {
                            setState(() {
                              _selectedTab = 0;
                            });
                          }, child: const Text('All')),
                      ),
                      Expanded(
                        child: TextButton(
                          style: _selectedTab == 1
                            ? Styles.activeTextButtonStyle
                            : Styles.inactiveTextButtonStyle,
                          onPressed: () {
                            setState(() {
                              _selectedTab = 1;
                            });
                          }, child: const Text('Unread')
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_selectedTab == 0)
                    for (var item in receivedNotifications)
                      NotificationItemCard(item, key: ValueKey(item.id)),
                  if (_selectedTab == 1)
                    for (var item in unreadNotifications)
                      NotificationItemCard(item, key: ValueKey(item.id))
                ],
              ),
            ),
          ),
        ]),
    );
  }
}