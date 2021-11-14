
import 'package:flutter/material.dart';

abstract class NavigatorUtils {
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen));
  }
}