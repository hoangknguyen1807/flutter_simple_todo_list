import 'package:flutter/material.dart';
import 'package:simple_todo_list/src/themes/styles.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: const CircularProgressIndicator.adaptive(),
    );
  }
}