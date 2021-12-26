import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_todo_list/src/models/local_notification/local_notification.model.dart';
import 'package:simple_todo_list/src/providers/notifications_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:provider/provider.dart';

class NotificationItemCard extends StatefulWidget {

  const NotificationItemCard(this.notification, { Key? key }) : super(key: key);

  final LocalNotificationModel notification;

  @override
  _NotificationItemCardState createState() => _NotificationItemCardState();
}

class _NotificationItemCardState extends State<NotificationItemCard> {

  final timeFormat = DateFormat.jm();
  final weekDayFormat = DateFormat.E();
  late LocalNotificationModel _notificationModel;

  @override
  void initState() {
    _notificationModel = widget.notification;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      child: Card(
        elevation: 1,
        child: Row(children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_notificationModel.title,
                    style: _notificationModel.isRead
                      ? const TextStyle(fontSize: 17)
                      : Styles.unreadItemTitle),
                  const SizedBox(height: 6),
                  Text(_notificationModel.body,
                    style: _notificationModel.isRead
                      ? null
                      : Styles.unreadItemSubtitle)
              ]),
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(DateUtils.isSameDay(_notificationModel.scheduledTime, DateTime.now())
                ? timeFormat.format(_notificationModel.scheduledTime)
                : weekDayFormat.format(_notificationModel.scheduledTime),
                style: (_notificationModel.isRead)
                ? null : const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              if (!_notificationModel.isRead)
                const CircleAvatar(radius: 6,
                  child: SizedBox(), backgroundColor: Colors.green)
            ]),
          const SizedBox(width: 10)
        ]),
      ),
      onTap: () {
        if (!_notificationModel.isRead){
          setState(() {
            _notificationModel.isRead = true;
          });

          final notiProvider = context.read<NotificationsProvider>();
          notiProvider.saveToHive();
        }
      },
    );
  }
}