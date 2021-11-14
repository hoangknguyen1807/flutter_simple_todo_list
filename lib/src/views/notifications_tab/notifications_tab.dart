import 'package:flutter/cupertino.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({ Key? key }) : super(key: key);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text("Notifications")),
    );
  }
}