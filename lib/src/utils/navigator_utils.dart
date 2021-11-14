
import 'package:flutter/material.dart';

class NavigatorUtils {
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen));
  }
}