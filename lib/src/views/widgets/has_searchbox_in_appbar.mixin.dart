import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_list/src/models/todo_item/todo_item.model.dart';
import 'package:simple_todo_list/src/themes/styles.dart';
import 'todo_item_card.dart';

mixin HasSearchBoxInAppBar {

  bool isSearching = false;
  String query = '';
  final List<ToDoItemModel> searchResultToDos = [];
  
  int updateSearchResult(String query, List<ToDoItemModel> allItems) {
    searchResultToDos.clear();
    searchResultToDos.addAll(
      allItems.where((item) {
        final lowerCasedQuery = query.toLowerCase();
        final clA = item.title.toLowerCase().contains(lowerCasedQuery);
        final clB = item.description.toLowerCase().contains(lowerCasedQuery);
        return clA || clB;
      })
    );
    return searchResultToDos.length;
  }

  void toggleSearch() {
    query = '';
    isSearching = !isSearching;
  }

  Widget buildSearchIconButton({required void Function() onPressed}) {
    return IconButton(
      icon: Icon(isSearching
              ? CupertinoIcons.xmark
              : CupertinoIcons.search, size: 24),
      onPressed: onPressed,
    );
  }

  Widget buildSearchBoxAppBar({required void Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          hintText: 'Search your todos ...',
        )
      ),
    );
  }

  Widget buildSearchToDoResult() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 8, top: 6, bottom: 10),
              child: const Text('Tasks', style: Styles.sectionTitleBold)),
            for (var result in searchResultToDos)
              ToDoItemCard(result, key: UniqueKey())
          ],
        ),
      ),
    );
  }

}