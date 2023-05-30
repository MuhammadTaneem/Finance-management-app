import 'package:flutter/material.dart';

import '../main.dart';
enum SnackbarType { success, error, warning }

class SnackWidget  {

  void showMessage({required String message, SnackbarType snackbarType = SnackbarType.success}) {

    Color backgroundColor;
    switch(snackbarType) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.yellow;
        break;
    }
    final snackBar = SnackBar(content: Text(message,), backgroundColor: backgroundColor,);
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
  }
}
