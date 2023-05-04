import 'package:flutter/material.dart';

class Alerts {
  void alertPrimary(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(msg),
          content: Row(
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 50,
              ),
              Text("Review Added Successfully"),
            ],
          ),
        );
      },
    );
  }
}
