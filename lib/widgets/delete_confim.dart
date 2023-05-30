import 'package:flutter/material.dart';

Future<bool> showDeleteWarning(BuildContext context) async {
  bool result = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete warning",style: TextStyle(color: Colors.red), ),
        content: const Text("Are you sure you want to delete this item?"),
        actions: <Widget>[
          TextButton (
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton (
            child: const Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ).then((value) => result = value);

  return result;
}

