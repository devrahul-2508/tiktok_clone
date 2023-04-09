import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/home_screen.dart';

const textDecoration = InputDecoration(
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    disabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {},
        textColor: Colors.white,
      )));
}

void nextScreen(BuildContext context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

void nextScreenReplace(BuildContext context, page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}


