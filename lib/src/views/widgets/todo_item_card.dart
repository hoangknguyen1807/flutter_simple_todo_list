import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_list/src/models/todo_item.model.dart';
import 'package:simple_todo_list/src/providers/todo_items_provider.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'package:simple_todo_list/src/utils/navigator_utils.dart';
import 'package:simple_todo_list/src/views/edit_todo_item_page/edit_todo_item_page.dart';

class ToDoItemCard extends StatefulWidget {
  const ToDoItemCard(this.toDoModel, { Key? key }) : super(key: key);

  final ToDoItemModel toDoModel;

  @override
  State<ToDoItemCard> createState() => _ToDoItemCardState();
}

class _ToDoItemCardState extends State<ToDoItemCard> {

  final today = DateTime.now();
  final dateFormat = DateFormat.yMMMEd();
  final timeFormat = DateFormat.Hm();

  late ToDoItemModel _toDoModel;

  TextStyle _getTextStyleForToDoTime(ToDoItemModel toDoModel) {

    if (!toDoModel.isDone) {
      Color textColor;
      final occurTime = toDoModel.occurTime;
      
      if (today.isAfter(occurTime)) {
        textColor = Styles.overdueTextColor;
      } else if (DateUtils.isSameDay(today, occurTime)) {
        textColor = Styles.upcomingTextColor;
      } else {
        textColor = Styles.futureTextColor;
      }

      return TextStyle(color: textColor, fontWeight: FontWeight.w500);
    } else {
      return const TextStyle(
        color: Styles.archivedTextColor,
        decoration: TextDecoration.lineThrough,
        decorationThickness: 1.0,
      );
    }
  }

  TextStyle _getTextStyleForToDoLabel(ToDoItemModel toDoModel) {
    if (toDoModel.isDone) {
      return Styles.archivedItemLabel;
    } else if (today.isAfter(toDoModel.occurTime)) {
      return Styles.overdueItemLabel;
    } else {
      return Styles.listItemLabel;
    }
  }

  @override
  void initState() {
    _toDoModel = widget.toDoModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ToDoItemsProvider>();
    return GestureDetector(
      onTap: () {
        NavigatorUtils.navigateToScreen(context, EditToDoItemPage(_toDoModel));
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
              scale: 1.25,
              child: Checkbox(
                value: _toDoModel.isDone,
                shape: const CircleBorder(side: BorderSide(width: 0.0)),
                onChanged: (value) {
                  setState(() => _toDoModel.isDone = (value == true));
                  final toDoItemsProvider = context.read<ToDoItemsProvider>();
                  Future.delayed(const Duration(milliseconds: 750), () {
                    toDoItemsProvider.saveToHive();
                  });
                },
              )
            ),
            const SizedBox(width: 4),
            Expanded(child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_toDoModel.title,
                    style: _getTextStyleForToDoLabel(_toDoModel)),
                  Text('🗓   ' +
                    (DateUtils.isSameDay(today, _toDoModel.occurTime)
                      ? 'Today' : dateFormat.format(_toDoModel.occurTime))
                    + ' - ' + timeFormat.format(_toDoModel.occurTime)
                    + (_toDoModel.isOverdue() ? ' (overdue)' : ''),
                    style: _getTextStyleForToDoTime(_toDoModel),
                  )
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.only(top: 16, right: 16),
              alignment: Alignment.center,
              child: const Icon(Icons.edit, size: 24, color: Colors.grey)
            )
          ],
        )
      ),
    );
  }
}