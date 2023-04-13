import 'package:flutter/material.dart';

class LinearProgressDialog extends StatelessWidget {
  final String message;
  final double value;

  LinearProgressDialog({required this.message, required this.value});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              message ?? "Please wait...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

