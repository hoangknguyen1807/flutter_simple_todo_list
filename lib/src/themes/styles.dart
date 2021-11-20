import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle sectionTitleNormal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle sectionTitleBold = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textSecondary = TextStyle(
    color: CupertinoColors.inactiveGray,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle listItemLabel = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle overdueItemLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: overdueTextColor,
  );

  static const TextStyle archivedItemLabel = TextStyle(
    color: archivedTextColor,
    fontSize: 18,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
  );

  static const Color dividerColor = Color(0xFFD9D9D9);

  static const Color scaffoldBackgroundColor = Color(0xfff0f0f0);

  static const Color upcomingTextColor = Colors.orange;

  static const Color overdueTextColor = Colors.red;

  static const Color futureTextColor = Color(0xff10a2ff);

  static const Color archivedTextColor = Color.fromRGBO(128, 128, 128, 1);
}