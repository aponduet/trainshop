import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String? message;
  const CustomSnackbar({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.teal,
      //closeIconColor: Colors.yellow,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
      width: 300,
      content: Center(
        child: Text(
          message ?? 'action executed',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
